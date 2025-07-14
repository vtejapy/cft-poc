#!/bin/bash

# Clean up CloudFormation stack and resources
# Usage: ./cleanup.sh <environment> [stack-name]

set -e

# Configuration
ENVIRONMENT=${1}
STACK_NAME=${2:-"infrastructure-$ENVIRONMENT"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate input
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}Error: Environment is required${NC}"
    echo "Usage: $0 <environment> [stack-name]"
    echo "Environments: dev, stg, prod"
    exit 1
fi

echo -e "${YELLOW}=== CloudFormation Stack Cleanup ===${NC}"
echo "Environment: $ENVIRONMENT"
echo "Stack Name: $STACK_NAME"
echo ""

# Safety check for production
if [ "$ENVIRONMENT" == "prod" ]; then
    echo -e "${RED}WARNING: You are about to DELETE the PRODUCTION stack!${NC}"
    echo -e "${RED}This action is IRREVERSIBLE and will destroy all resources!${NC}"
    echo ""
    read -p "Type 'DELETE PRODUCTION' to confirm: " -r
    if [ "$REPLY" != "DELETE PRODUCTION" ]; then
        echo -e "${YELLOW}Cleanup cancelled${NC}"
        exit 0
    fi
    echo ""
fi

# Additional confirmation for all environments
echo -e "${YELLOW}This will permanently delete the following stack and ALL its resources:${NC}"
echo "  Stack: $STACK_NAME"
echo "  Environment: $ENVIRONMENT"
echo ""
echo "Resources that will be deleted include:"
echo "  - RDS database (with all data)"
echo "  - S3 buckets (with all files)"
echo "  - Lambda functions"
echo "  - API Gateway"
echo "  - Amazon Connect instance"
echo "  - VPC and networking components"
echo "  - All other associated resources"
echo ""
read -p "Are you absolutely sure? (yes/NO): " -r
if [ "$REPLY" != "yes" ]; then
    echo -e "${YELLOW}Cleanup cancelled${NC}"
    exit 0
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Check if stack exists
if ! aws cloudformation describe-stacks --stack-name "$STACK_NAME" &>/dev/null; then
    echo -e "${YELLOW}Stack '$STACK_NAME' does not exist${NC}"
    exit 0
fi

echo -e "${BLUE}Starting cleanup process...${NC}"
echo ""

# Get current stack status
STACK_STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].StackStatus' --output text)
echo "Current stack status: $STACK_STATUS"

# Check if stack is in a state that can be deleted
if [[ "$STACK_STATUS" == *"IN_PROGRESS"* ]]; then
    echo -e "${RED}Error: Stack is currently being modified. Please wait for the operation to complete.${NC}"
    exit 1
fi

# Pre-cleanup: Handle resources that might prevent deletion

echo -e "${BLUE}Phase 1: Preparing resources for deletion...${NC}"

# Disable termination protection if enabled
echo "Checking termination protection..."
TERMINATION_PROTECTION=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].EnableTerminationProtection' --output text 2>/dev/null || echo "false")

if [ "$TERMINATION_PROTECTION" == "true" ]; then
    echo "Disabling termination protection..."
    aws cloudformation update-termination-protection \
        --stack-name "$STACK_NAME" \
        --no-enable-termination-protection
fi

# Handle S3 buckets - they need to be emptied before deletion
echo "Checking for S3 buckets that need to be emptied..."
S3_BUCKETS=$(aws cloudformation describe-stack-resources \
    --stack-name "$STACK_NAME" \
    --query 'StackResources[?ResourceType==`AWS::S3::Bucket`].PhysicalResourceId' \
    --output text 2>/dev/null || echo "")

if [ -n "$S3_BUCKETS" ]; then
    echo "Found S3 buckets, emptying them..."
    for bucket in $S3_BUCKETS; do
        if aws s3 ls "s3://$bucket" &>/dev/null; then
            echo "  Emptying bucket: $bucket"
            aws s3 rm "s3://$bucket" --recursive --quiet || true
            
            # Remove all versions and delete markers if versioning is enabled
            aws s3api list-object-versions \
                --bucket "$bucket" \
                --query 'Versions[*].[Key,VersionId]' \
                --output text 2>/dev/null | while read key version; do
                if [ "$key" != "None" ] && [ "$version" != "None" ]; then
                    aws s3api delete-object --bucket "$bucket" --key "$key" --version-id "$version" --quiet || true
                fi
            done
            
            aws s3api list-object-versions \
                --bucket "$bucket" \
                --query 'DeleteMarkers[*].[Key,VersionId]' \
                --output text 2>/dev/null | while read key version; do
                if [ "$key" != "None" ] && [ "$version" != "None" ]; then
                    aws s3api delete-object --bucket "$bucket" --key "$key" --version-id "$version" --quiet || true
                fi
            done
        fi
    done
fi

# Handle RDS snapshots - delete manual snapshots
echo "Checking for RDS manual snapshots..."
RDS_INSTANCES=$(aws cloudformation describe-stack-resources \
    --stack-name "$STACK_NAME" \
    --query 'StackResources[?ResourceType==`AWS::RDS::DBInstance`].PhysicalResourceId' \
    --output text 2>/dev/null || echo "")

if [ -n "$RDS_INSTANCES" ]; then
    for instance in $RDS_INSTANCES; do
        echo "  Checking snapshots for RDS instance: $instance"
        MANUAL_SNAPSHOTS=$(aws rds describe-db-snapshots \
            --db-instance-identifier "$instance" \
            --snapshot-type manual \
            --query 'DBSnapshots[*].DBSnapshotIdentifier' \
            --output text 2>/dev/null || echo "")
        
        if [ -n "$MANUAL_SNAPSHOTS" ]; then
            for snapshot in $MANUAL_SNAPSHOTS; do
                echo "    Deleting manual snapshot: $snapshot"
                aws rds delete-db-snapshot --db-snapshot-identifier "$snapshot" || true
            done
        fi
    done
fi

echo -e "${BLUE}Phase 2: Deleting CloudFormation stack...${NC}"

# Delete the stack
echo "Initiating stack deletion..."
aws cloudformation delete-stack --stack-name "$STACK_NAME"

echo "Waiting for stack deletion to complete..."
echo "This may take 15-30 minutes depending on the resources being deleted."
echo ""

# Wait for deletion with progress updates
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME" &
WAIT_PID=$!

# Show progress while waiting
while kill -0 $WAIT_PID 2>/dev/null; do
    # Check if stack still exists
    if aws cloudformation describe-stacks --stack-name "$STACK_NAME" &>/dev/null; then
        CURRENT_STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || echo "UNKNOWN")
        echo -e "${BLUE}Status: $CURRENT_STATUS${NC} - $(date)"
    else
        echo -e "${GREEN}Stack deleted successfully${NC} - $(date)"
        break
    fi
    sleep 30
done

wait $WAIT_PID 2>/dev/null || true

# Check final status
if aws cloudformation describe-stacks --stack-name "$STACK_NAME" &>/dev/null; then
    FINAL_STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || echo "UNKNOWN")
    
    if [ "$FINAL_STATUS" == "DELETE_FAILED" ]; then
        echo ""
        echo -e "${RED}✗ Stack deletion failed!${NC}"
        echo "Final Status: $FINAL_STATUS"
        
        # Show failed resources
        echo ""
        echo -e "${BLUE}Resources that failed to delete:${NC}"
        aws cloudformation describe-stack-events \
            --stack-name "$STACK_NAME" \
            --query 'StackEvents[?ResourceStatus==`DELETE_FAILED`].[Timestamp,LogicalResourceId,ResourceStatusReason]' \
            --output table
        
        echo ""
        echo "You may need to manually clean up these resources and retry the deletion."
        exit 1
    else
        echo ""
        echo -e "${YELLOW}Stack status: $FINAL_STATUS${NC}"
        echo "Stack deletion may still be in progress."
    fi
else
    echo ""
    echo -e "${GREEN}✓ Stack deleted successfully!${NC}"
    echo "All resources have been cleaned up."
fi

echo ""
echo -e "${GREEN}Cleanup process completed!${NC}"
#!/bin/bash

# Check CloudFormation stack status and health
# Usage: ./check-status.sh <environment> [stack-name]

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

echo -e "${GREEN}=== CloudFormation Stack Status Check ===${NC}"
echo "Environment: $ENVIRONMENT"
echo "Stack Name: $STACK_NAME"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Check if stack exists
if ! aws cloudformation describe-stacks --stack-name "$STACK_NAME" &>/dev/null; then
    echo -e "${RED}Error: Stack '$STACK_NAME' does not exist${NC}"
    exit 1
fi

# Get stack information
STACK_INFO=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0]')
STACK_STATUS=$(echo "$STACK_INFO" | jq -r '.StackStatus')
CREATION_TIME=$(echo "$STACK_INFO" | jq -r '.CreationTime')
LAST_UPDATED=$(echo "$STACK_INFO" | jq -r '.LastUpdatedTime // "Never"')

# Determine status color
case $STACK_STATUS in
    *"COMPLETE"*)
        STATUS_COLOR=$GREEN
        ;;
    *"FAILED"* | *"ROLLBACK"*)
        STATUS_COLOR=$RED
        ;;
    *"IN_PROGRESS"*)
        STATUS_COLOR=$YELLOW
        ;;
    *)
        STATUS_COLOR=$NC
        ;;
esac

echo -e "${BLUE}=== Stack Overview ===${NC}"
echo -e "Status: ${STATUS_COLOR}$STACK_STATUS${NC}"
echo "Created: $CREATION_TIME"
echo "Last Updated: $LAST_UPDATED"
echo ""

# Show stack outputs
echo -e "${BLUE}=== Stack Outputs ===${NC}"
aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue,Description]' \
    --output table 2>/dev/null || echo "No outputs available"
echo ""

# Show nested stacks status
echo -e "${BLUE}=== Nested Stacks Status ===${NC}"
NESTED_STACKS=$(aws cloudformation list-stack-resources \
    --stack-name "$STACK_NAME" \
    --query 'StackResourceSummaries[?ResourceType==`AWS::CloudFormation::Stack`].[LogicalResourceId,ResourceStatus,PhysicalResourceId]' \
    --output text 2>/dev/null)

if [ -n "$NESTED_STACKS" ]; then
    printf "%-25s %-20s %s\n" "Stack Name" "Status" "Physical ID"
    printf "%-25s %-20s %s\n" "----------" "------" "-----------"
    
    while IFS=$'\t' read -r logical_id status physical_id; do
        case $status in
            *"COMPLETE"*)
                STATUS_COLOR=$GREEN
                ;;
            *"FAILED"* | *"ROLLBACK"*)
                STATUS_COLOR=$RED
                ;;
            *"IN_PROGRESS"*)
                STATUS_COLOR=$YELLOW
                ;;
            *)
                STATUS_COLOR=$NC
                ;;
        esac
        printf "%-25s ${STATUS_COLOR}%-20s${NC} %s\n" "$logical_id" "$status" "$physical_id"
    done <<< "$NESTED_STACKS"
else
    echo "No nested stacks found"
fi
echo ""

# Check for any failed resources
echo -e "${BLUE}=== Resource Health Check ===${NC}"
FAILED_RESOURCES=$(aws cloudformation describe-stack-events \
    --stack-name "$STACK_NAME" \
    --query 'StackEvents[?ResourceStatus==`CREATE_FAILED` || ResourceStatus==`UPDATE_FAILED` || ResourceStatus==`DELETE_FAILED`].[Timestamp,LogicalResourceId,ResourceStatus,ResourceStatusReason]' \
    --output text 2>/dev/null | head -10)

if [ -n "$FAILED_RESOURCES" ]; then
    echo -e "${RED}Recent Failed Resources:${NC}"
    printf "%-20s %-30s %-15s %s\n" "Timestamp" "Resource" "Status" "Reason"
    printf "%-20s %-30s %-15s %s\n" "---------" "--------" "------" "------"
    while IFS=$'\t' read -r timestamp resource status reason; do
        printf "%-20s %-30s ${RED}%-15s${NC} %s\n" "$(date -d "$timestamp" '+%Y-%m-%d %H:%M' 2>/dev/null || echo "$timestamp")" "$resource" "$status" "$reason"
    done <<< "$FAILED_RESOURCES"
else
    echo -e "${GREEN}✓ No failed resources found${NC}"
fi
echo ""

# Show recent events
echo -e "${BLUE}=== Recent Events (Last 10) ===${NC}"
aws cloudformation describe-stack-events \
    --stack-name "$STACK_NAME" \
    --query 'StackEvents[0:10].[Timestamp,ResourceStatus,ResourceType,LogicalResourceId]' \
    --output table 2>/dev/null || echo "No events available"
echo ""

# Check drift status if stack is in a stable state
if [[ "$STACK_STATUS" == *"COMPLETE"* ]]; then
    echo -e "${BLUE}=== Drift Detection ===${NC}"
    echo "Starting drift detection..."
    
    DRIFT_ID=$(aws cloudformation detect-stack-drift \
        --stack-name "$STACK_NAME" \
        --query 'StackDriftDetectionId' \
        --output text 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # Wait for drift detection to complete
        sleep 5
        
        DRIFT_STATUS=$(aws cloudformation describe-stack-drift-detection-status \
            --stack-drift-detection-id "$DRIFT_ID" \
            --query 'DetectionStatus' \
            --output text 2>/dev/null)
        
        while [ "$DRIFT_STATUS" == "DETECTION_IN_PROGRESS" ]; do
            echo "Drift detection in progress..."
            sleep 3
            DRIFT_STATUS=$(aws cloudformation describe-stack-drift-detection-status \
                --stack-drift-detection-id "$DRIFT_ID" \
                --query 'DetectionStatus' \
                --output text 2>/dev/null)
        done
        
        if [ "$DRIFT_STATUS" == "DETECTION_COMPLETE" ]; then
            DRIFT_RESULT=$(aws cloudformation describe-stack-drift-detection-status \
                --stack-drift-detection-id "$DRIFT_ID" \
                --query 'StackDriftStatus' \
                --output text 2>/dev/null)
            
            case $DRIFT_RESULT in
                "IN_SYNC")
                    echo -e "${GREEN}✓ Stack is in sync (no drift detected)${NC}"
                    ;;
                "DRIFTED")
                    echo -e "${YELLOW}⚠ Stack drift detected${NC}"
                    ;;
                *)
                    echo -e "${YELLOW}Drift status: $DRIFT_RESULT${NC}"
                    ;;
            esac
        else
            echo -e "${YELLOW}Drift detection failed or was interrupted${NC}"
        fi
    else
        echo -e "${YELLOW}Could not start drift detection${NC}"
    fi
else
    echo -e "${YELLOW}Skipping drift detection (stack not in stable state)${NC}"
fi

echo ""
echo -e "${GREEN}Status check complete!${NC}"

# Return appropriate exit code based on stack status
case $STACK_STATUS in
    *"COMPLETE"*)
        exit 0
        ;;
    *"FAILED"* | *"ROLLBACK"*)
        exit 1
        ;;
    *)
        exit 2
        ;;
esac
#!/bin/bash

# Deploy CloudFormation stack
# Usage: ./deploy.sh <environment> [stack-name] [bucket-name]

set -e

# Configuration
ENVIRONMENT=${1}
STACK_NAME=${2:-"infrastructure-$ENVIRONMENT"}
BUCKET_NAME=${3:-"cloudformation-templates-bucket"}
PARAMETERS_FILE="cloudformation/parameters/$ENVIRONMENT.json"
MAIN_TEMPLATE_URL="https://$BUCKET_NAME.s3.amazonaws.com/main.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate input
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}Error: Environment is required${NC}"
    echo "Usage: $0 <environment> [stack-name] [bucket-name]"
    echo "Environments: dev, stg, prod"
    exit 1
fi

if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "stg" ] && [ "$ENVIRONMENT" != "prod" ]; then
    echo -e "${RED}Error: Invalid environment. Must be dev, stg, or prod${NC}"
    exit 1
fi

if [ ! -f "$PARAMETERS_FILE" ]; then
    echo -e "${RED}Error: Parameters file not found: $PARAMETERS_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}=== CloudFormation Deployment Script ===${NC}"
echo "Environment: $ENVIRONMENT"
echo "Stack Name: $STACK_NAME"
echo "Parameters: $PARAMETERS_FILE"
echo "Template: $MAIN_TEMPLATE_URL"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Get AWS account and region info
AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "unknown")
AWS_REGION=$(aws configure get region 2>/dev/null || echo "us-east-1")

echo "AWS Account: $AWS_ACCOUNT"
echo "AWS Region: $AWS_REGION"
echo ""

# Confirm deployment for production
if [ "$ENVIRONMENT" == "prod" ]; then
    echo -e "${YELLOW}WARNING: You are about to deploy to PRODUCTION${NC}"
    read -p "Are you sure you want to continue? (yes/NO): " -r
    if [ "$REPLY" != "yes" ]; then
        echo -e "${YELLOW}Deployment cancelled${NC}"
        exit 0
    fi
fi

# Check if stack exists
STACK_EXISTS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || echo "DOES_NOT_EXIST")

if [ "$STACK_EXISTS" == "DOES_NOT_EXIST" ]; then
    echo -e "${BLUE}Creating new stack: $STACK_NAME${NC}"
    OPERATION="create-stack"
    WAIT_CONDITION="stack-create-complete"
else
    echo -e "${BLUE}Updating existing stack: $STACK_NAME${NC}"
    echo "Current status: $STACK_EXISTS"
    OPERATION="update-stack"
    WAIT_CONDITION="stack-update-complete"
    
    # Check if stack is in a state that can be updated
    if [[ "$STACK_EXISTS" == *"IN_PROGRESS"* ]]; then
        echo -e "${RED}Error: Stack is currently being modified. Please wait for the operation to complete.${NC}"
        exit 1
    fi
fi

# Build parameters from JSON file
PARAMETERS=$(python3 -c "
import json
import sys
try:
    with open('$PARAMETERS_FILE', 'r') as f:
        data = json.load(f)
    params = []
    for key, value in data.get('Parameters', {}).items():
        params.append(f'ParameterKey={key},ParameterValue={value}')
    print(' '.join(params))
except Exception as e:
    print(f'Error parsing parameters file: {e}', file=sys.stderr)
    sys.exit(1)
")

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to parse parameters file${NC}"
    exit 1
fi

# Add template bucket parameters
PARAMETERS="$PARAMETERS ParameterKey=TemplatesBucketName,ParameterValue=$BUCKET_NAME ParameterKey=TemplatesPrefix,ParameterValue=templates/"

echo "Deploying stack..."
echo ""

# Deploy the stack
DEPLOYMENT_OUTPUT=$(aws cloudformation $OPERATION \
    --stack-name "$STACK_NAME" \
    --template-url "$MAIN_TEMPLATE_URL" \
    --parameters $PARAMETERS \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --tags Key=Environment,Value=$ENVIRONMENT Key=DeployedBy,Value=script Key=DeployedAt,Value=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
    --output text 2>&1) || {
    
    if echo "$DEPLOYMENT_OUTPUT" | grep -q "No updates are to be performed"; then
        echo -e "${YELLOW}No changes detected - stack is already up to date${NC}"
        exit 0
    else
        echo -e "${RED}Deployment failed:${NC}"
        echo "$DEPLOYMENT_OUTPUT"
        exit 1
    fi
}

if [ "$OPERATION" == "create-stack" ]; then
    STACK_ID=$(echo "$DEPLOYMENT_OUTPUT")
    echo "Stack ID: $STACK_ID"
fi

echo -e "${BLUE}Waiting for stack operation to complete...${NC}"
echo "This may take 15-30 minutes depending on the resources being created."
echo ""

# Wait for completion with progress updates
aws cloudformation wait "$WAIT_CONDITION" --stack-name "$STACK_NAME" &
WAIT_PID=$!

# Show progress while waiting
while kill -0 $WAIT_PID 2>/dev/null; do
    CURRENT_STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || echo "UNKNOWN")
    echo -e "${BLUE}Status: $CURRENT_STATUS${NC} - $(date)"
    sleep 30
done

wait $WAIT_PID
WAIT_RESULT=$?

# Check final status
FINAL_STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || echo "UNKNOWN")

if [ $WAIT_RESULT -eq 0 ] && [[ "$FINAL_STATUS" == *"COMPLETE"* ]]; then
    echo ""
    echo -e "${GREEN}✓ Stack deployment completed successfully!${NC}"
    echo "Final Status: $FINAL_STATUS"
    
    # Show stack outputs
    echo ""
    echo -e "${BLUE}Stack Outputs:${NC}"
    aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue,Description]' \
        --output table
        
else
    echo ""
    echo -e "${RED}✗ Stack deployment failed!${NC}"
    echo "Final Status: $FINAL_STATUS"
    
    # Show stack events for troubleshooting
    echo ""
    echo -e "${BLUE}Recent Stack Events:${NC}"
    aws cloudformation describe-stack-events \
        --stack-name "$STACK_NAME" \
        --query 'StackEvents[0:10].[Timestamp,ResourceStatus,ResourceType,LogicalResourceId,ResourceStatusReason]' \
        --output table
    
    exit 1
fi
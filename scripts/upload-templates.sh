#!/bin/bash

# Upload CloudFormation templates to S3
# Usage: ./upload-templates.sh [bucket-name] [prefix]

set -e

# Configuration
BUCKET_NAME=${1:-"cloudformation-templates-bucket"}
PREFIX=${2:-"templates/"}
TEMPLATES_DIR="cloudformation/templates"
MAIN_TEMPLATE="cloudformation/main.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== CloudFormation Template Upload Script ===${NC}"
echo "Bucket: $BUCKET_NAME"
echo "Prefix: $PREFIX"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Check if bucket exists
if ! aws s3 ls "s3://$BUCKET_NAME" &> /dev/null; then
    echo -e "${YELLOW}Warning: Bucket $BUCKET_NAME does not exist or is not accessible${NC}"
    read -p "Do you want to create the bucket? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Creating bucket $BUCKET_NAME..."
        aws s3 mb "s3://$BUCKET_NAME"
        
        # Enable versioning
        aws s3api put-bucket-versioning \
            --bucket "$BUCKET_NAME" \
            --versioning-configuration Status=Enabled
        
        echo -e "${GREEN}Bucket created successfully${NC}"
    else
        echo -e "${RED}Exiting...${NC}"
        exit 1
    fi
fi

# Upload individual templates
echo "Uploading templates to S3..."

for template in "$TEMPLATES_DIR"/*.yaml; do
    if [ -f "$template" ]; then
        filename=$(basename "$template")
        s3_path="s3://$BUCKET_NAME/$PREFIX$filename"
        
        echo "Uploading $filename..."
        aws s3 cp "$template" "$s3_path" --quiet
        
        # Validate template
        template_url="https://$BUCKET_NAME.s3.amazonaws.com/$PREFIX$filename"
        if aws cloudformation validate-template --template-url "$template_url" &> /dev/null; then
            echo -e "  ${GREEN}✓ Valid${NC}"
        else
            echo -e "  ${RED}✗ Invalid template${NC}"
            exit 1
        fi
    fi
done

# Upload main template
echo "Uploading main template..."
aws s3 cp "$MAIN_TEMPLATE" "s3://$BUCKET_NAME/main.yaml" --quiet

# Validate main template
main_template_url="https://$BUCKET_NAME.s3.amazonaws.com/main.yaml"
if aws cloudformation validate-template --template-url "$main_template_url" &> /dev/null; then
    echo -e "${GREEN}✓ Main template valid${NC}"
else
    echo -e "${RED}✗ Main template invalid${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}All templates uploaded successfully!${NC}"
echo ""
echo "Template URLs:"
echo "Main: $main_template_url"
echo "Templates: https://$BUCKET_NAME.s3.amazonaws.com/$PREFIX"
echo ""
echo "You can now deploy the stack using:"
echo "  ./deploy.sh <environment>"
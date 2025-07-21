#!/bin/bash

# AWS Infrastructure Destroy Script

set -e

echo "🗑️  AWS Infrastructure Cleanup Tool"
echo "==================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please ensure .env file exists with your AWS credentials."
    exit 1
fi

# Load environment variables
source .env

# Validate required environment variables
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ Error: AWS credentials not set in .env file!"
    exit 1
fi

# Confirmation prompt
echo "⚠️  WARNING: This will destroy all AWS resources created by this stack!"
echo "This action cannot be undone."
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo "❌ Destruction cancelled."
    exit 0
fi

# Create modified entrypoint for destroy
docker run -it \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_REGION="${AWS_REGION:-us-east-1}" \
    --entrypoint /bin/bash \
    aws-infrastructure-deployer \
    -c "cd /app && cdk destroy --all --force"

echo ""
echo "✅ Infrastructure cleanup completed!"
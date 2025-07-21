#!/bin/bash

# AWS Infrastructure Deployment Script

set -e

echo "🚀 AWS Infrastructure Deployment Tool"
echo "===================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please copy .env.template to .env and add your AWS credentials."
    exit 1
fi

# Load environment variables
source .env

# Validate required environment variables
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ Error: AWS credentials not set in .env file!"
    exit 1
fi

# Build Docker image
echo "📦 Building Docker image..."
docker build -t aws-infrastructure-deployer .

# Run deployment
echo "🔧 Starting deployment..."
echo "Region: ${AWS_REGION:-us-east-1}"
echo ""

docker run -it \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_REGION="${AWS_REGION:-us-east-1}" \
    -v "$(pwd)/cdk-outputs:/app/cdk.out" \
    aws-infrastructure-deployer

echo ""
echo "✅ Deployment process completed!"
echo "Check the output above for your resource URLs and endpoints."
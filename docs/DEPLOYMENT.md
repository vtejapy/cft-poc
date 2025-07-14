# Deployment Guide

## Prerequisites

### Required Tools
- AWS CLI v2.x or later
- Python 3.7+ (for parameter parsing)
- jq (for JSON processing in status scripts)
- Git (for version control)

### AWS Configuration
```bash
# Configure AWS CLI
aws configure

# Verify configuration
aws sts get-caller-identity
```

### Required Permissions
The deploying user/role needs the following permissions:
- CloudFormation: Full access
- IAM: Create/manage roles and policies
- VPC: Create/manage networking components
- RDS: Create/manage database instances
- Lambda: Create/manage functions
- API Gateway: Create/manage APIs
- Amazon Connect: Create/manage instances
- S3: Create/manage buckets
- DynamoDB: Create/manage tables
- Kinesis: Create/manage streams
- EventBridge: Create/manage rules
- Secrets Manager: Create/manage secrets
- KMS: Use default AWS managed keys

## Pre-Deployment Setup

### 1. Prepare Templates Bucket

Create an S3 bucket for storing CloudFormation templates:

```bash
# Create bucket for templates
aws s3 mb s3://your-cloudformation-templates-bucket

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket your-cloudformation-templates-bucket \
  --versioning-configuration Status=Enabled
```

### 2. Update Parameter Files

Edit the parameter files for your environment:

#### Development (`cloudformation/parameters/dev.json`)
```json
{
  "Parameters": {
    "Environment": "dev",
    "Client": "your-client-name",
    "Region": "us-east-1",
    "TemplatesBucketName": "your-cloudformation-templates-bucket",
    // ... other parameters
  }
}
```

#### Production (`cloudformation/parameters/prod.json`)
```json
{
  "Parameters": {
    "Environment": "prod",
    "Client": "your-client-name",
    "Region": "us-east-1",
    "TemplatesBucketName": "your-cloudformation-templates-bucket-prod",
    // ... other parameters with production values
  }
}
```

### 3. Environment-Specific Configuration

Update the following parameters for each environment:

| Parameter | Dev Value | Prod Value | Description |
|-----------|-----------|------------|-------------|
| VpcCidr | 10.113.0.0/16 | 10.115.0.0/16 | VPC CIDR block |
| RDSInstanceClass | db.t3.micro | db.r5.xlarge | RDS instance size |
| RDSAllocatedStorage | 20 | 500 | RDS storage in GB |
| RDSBackupRetentionPeriod | 7 | 30 | Backup retention days |
| LambdaMemorySize | 128 | 512 | Lambda memory allocation |

## Deployment Process

### Step 1: Upload Templates

Upload all CloudFormation templates to S3:

```bash
# Make script executable
chmod +x scripts/upload-templates.sh

# Upload templates
./scripts/upload-templates.sh your-cloudformation-templates-bucket
```

This script will:
- Upload all templates to S3
- Validate each template
- Set appropriate permissions

### Step 2: Deploy Infrastructure

Deploy the complete infrastructure stack:

```bash
# Deploy to development
./scripts/deploy.sh dev

# Deploy to production (requires confirmation)
./scripts/deploy.sh prod
```

The deployment process includes:
1. **Pre-flight checks**: Validates parameters and AWS connectivity
2. **Stack creation/update**: Deploys nested CloudFormation stacks
3. **Progress monitoring**: Shows real-time deployment status
4. **Post-deployment validation**: Displays stack outputs

### Step 3: Verify Deployment

Check the deployment status:

```bash
# Check overall status
./scripts/check-status.sh dev

# Monitor specific stack
aws cloudformation describe-stacks --stack-name infrastructure-dev
```

## Deployment Sequence

The stacks are deployed in the following order based on dependencies:

```
1. VPC Stack (Foundation)
   ├── 2. S3 Stack
   ├── 3. RDS Stack
   ├── 4. VPC Endpoints Stack
   └── 5. DynamoDB Stack
       └── 6. IAM Stack
           └── 7. Kinesis Stack
               └── 8. Lambda Stack
                   ├── 9. API Gateway Stack
                   ├── 10. Connect Stack
                   └── 11. EventBridge Stack
```

## Stack Details

### 1. VPC Stack
- **Deploy Time**: 5-10 minutes
- **Resources**: VPC, subnets, gateways, route tables
- **Outputs**: VPC ID, subnet IDs, CIDR blocks

### 2. S3 Stack
- **Deploy Time**: 2-5 minutes
- **Resources**: S3 buckets with lifecycle policies
- **Outputs**: Bucket names and ARNs

### 3. RDS Stack
- **Deploy Time**: 15-25 minutes
- **Resources**: PostgreSQL instance, security groups, snapshots
- **Outputs**: Endpoint, port, secret ARN

### 4. VPC Endpoints Stack
- **Deploy Time**: 5-10 minutes
- **Resources**: VPC endpoints for AWS services
- **Outputs**: Endpoint IDs

### 5. DynamoDB Stack
- **Deploy Time**: 2-5 minutes
- **Resources**: DynamoDB table with GSIs
- **Outputs**: Table name and ARN

### 6. IAM Stack
- **Deploy Time**: 2-5 minutes
- **Resources**: Roles and policies for Lambda functions
- **Outputs**: Role ARNs

### 7. Kinesis Stack
- **Deploy Time**: 5-10 minutes
- **Resources**: Kinesis streams and Firehose
- **Outputs**: Stream names and ARNs

### 8. Lambda Stack
- **Deploy Time**: 10-15 minutes
- **Resources**: Lambda functions and layers
- **Outputs**: Function ARNs

### 9. API Gateway Stack
- **Deploy Time**: 5-10 minutes
- **Resources**: REST API with comprehensive endpoints
- **Outputs**: API ID and stage URL

### 10. Connect Stack
- **Deploy Time**: 10-15 minutes
- **Resources**: Connect instance, flows, queues
- **Outputs**: Instance ID and ARN

### 11. EventBridge Stack
- **Deploy Time**: 2-5 minutes
- **Resources**: Scheduled rules for automation
- **Outputs**: Rule ARNs

## Post-Deployment Configuration

### 1. Amazon Connect Setup

After deployment, configure Amazon Connect:

```bash
# Get Connect instance information
aws connect describe-instance --instance-id $(aws cloudformation describe-stacks \
  --stack-name infrastructure-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`ConnectInstanceId`].OutputValue' \
  --output text)
```

Manual configuration needed:
- Claim phone numbers
- Configure contact flows
- Create user accounts
- Set up routing profiles

### 2. Database Initialization

Initialize the PostgreSQL database:

```bash
# Get RDS endpoint
RDS_ENDPOINT=$(aws cloudformation describe-stacks \
  --stack-name infrastructure-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`RDSEndpoint`].OutputValue' \
  --output text)

# Get database credentials from Secrets Manager
SECRET_ARN=$(aws cloudformation describe-stacks \
  --stack-name infrastructure-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`RDSSecretArn`].OutputValue' \
  --output text)

# Retrieve credentials
aws secretsmanager get-secret-value --secret-id $SECRET_ARN
```

### 3. Lambda Function Configuration

Some Lambda functions may need additional configuration:
- Environment variables
- VPC settings
- Memory and timeout adjustments

### 4. API Gateway Testing

Test the API Gateway endpoints:

```bash
# Get API Gateway URL
API_URL=$(aws cloudformation describe-stacks \
  --stack-name infrastructure-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`APIGatewayStageUrl`].OutputValue' \
  --output text)

# Test health endpoint (if available)
curl -X GET "$API_URL/health"
```

## Monitoring Setup

### CloudWatch Dashboards

Create operational dashboards:
- Lambda function metrics
- RDS performance metrics
- API Gateway usage
- Connect real-time metrics

### Alarms

Set up CloudWatch alarms for:
- RDS CPU utilization
- Lambda error rates
- API Gateway 4xx/5xx errors
- Connect queue metrics

## Backup Verification

Verify backup configurations:

```bash
# Check RDS backup settings
aws rds describe-db-instances --db-instance-identifier postgres-rds-client-region-env

# Verify S3 lifecycle policies
aws s3api get-bucket-lifecycle-configuration --bucket recordings-bucket-name
```

## Troubleshooting

### Common Issues

#### 1. Stack Creation Timeout
**Symptoms**: Stack gets stuck in CREATE_IN_PROGRESS
**Solutions**:
- Check service limits
- Verify IAM permissions
- Review CloudFormation events

#### 2. RDS Creation Failures
**Symptoms**: RDS stack fails to create
**Solutions**:
- Check availability zone capacity
- Verify security group rules
- Ensure subnet group has subnets in different AZs

#### 3. Lambda VPC Configuration Issues
**Symptoms**: Lambda functions can't access resources
**Solutions**:
- Verify VPC endpoints are created
- Check security group rules
- Ensure NAT gateway connectivity

#### 4. API Gateway Integration Errors
**Symptoms**: API returns 5xx errors
**Solutions**:
- Check Lambda function permissions
- Verify API Gateway resource policies
- Review CloudWatch logs

### Diagnostic Commands

```bash
# Check stack events
aws cloudformation describe-stack-events --stack-name infrastructure-dev

# Review specific resource
aws cloudformation describe-stack-resource \
  --stack-name infrastructure-dev \
  --logical-resource-id ResourceName

# Check Lambda logs
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/

# Monitor RDS metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --start-time 2023-01-01T00:00:00Z \
  --end-time 2023-01-01T01:00:00Z \
  --period 300 \
  --statistics Average
```

## Rolling Back

If deployment fails or issues arise:

```bash
# Check current status
./scripts/check-status.sh dev

# Rollback to previous version (if update failed)
aws cloudformation cancel-update-stack --stack-name infrastructure-dev

# Complete cleanup (WARNING: Destroys all data)
./scripts/cleanup.sh dev
```

## Best Practices

### 1. Environment Isolation
- Use separate AWS accounts for prod/non-prod
- Different S3 buckets for template storage
- Unique parameter files per environment

### 2. Version Control
- Tag CloudFormation templates
- Store parameters in git
- Use meaningful commit messages

### 3. Testing
- Deploy to dev environment first
- Validate all functionality
- Perform load testing in staging

### 4. Security
- Use least privilege IAM roles
- Enable CloudTrail logging
- Regular security reviews

### 5. Monitoring
- Set up comprehensive monitoring
- Create runbooks for common issues
- Regular backup testing
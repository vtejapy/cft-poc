# Contact Center Infrastructure - CloudFormation

This repository contains CloudFormation templates for deploying a complete contact center infrastructure on AWS, including Amazon Connect, VPC networking, databases, Lambda functions, API Gateway, and supporting services.

## Architecture Overview

The infrastructure is deployed using a nested CloudFormation stack approach with the following components:

### Core Infrastructure
- **VPC**: Multi-AZ networking with public and private subnets
- **S3**: Multiple buckets for recordings, transcripts, exports, and voicemail
- **RDS**: PostgreSQL database for application data
- **DynamoDB**: NoSQL database for queue experience data

### Compute & Integration
- **Lambda**: Multiple functions for business logic and integrations
- **API Gateway**: RESTful APIs for contact center operations
- **Kinesis**: Data streaming for real-time analytics
- **EventBridge**: Event-driven automation

### Contact Center
- **Amazon Connect**: Contact center instance with flows and queues
- **VPC Endpoints**: Private connectivity to AWS services

### Security & Access
- **IAM**: Roles and policies for secure access
- **Security Groups**: Network-level security controls
- **KMS**: Encryption key management

## Stack Dependencies

```
VPC Stack (Foundation)
├── S3 Stack
├── RDS Stack  
├── VPC Endpoints Stack
└── DynamoDB Stack
    └── IAM Stack
        └── Kinesis Stack
            └── Lambda Stack
                ├── API Gateway Stack
                ├── Connect Stack
                └── EventBridge Stack
```

## Quick Start

### Prerequisites
- AWS CLI configured with appropriate permissions
- S3 bucket for storing CloudFormation templates
- Valid AWS account with sufficient service limits

### Deployment Steps

1. **Upload Templates to S3**
   ```bash
   # Run the upload script
   ./scripts/upload-templates.sh
   ```

2. **Deploy Infrastructure**
   ```bash
   # Deploy to development environment
   ./scripts/deploy.sh dev
   
   # Deploy to production environment  
   ./scripts/deploy.sh prod
   ```

3. **Validate Deployment**
   ```bash
   # Check stack status
   ./scripts/check-status.sh dev
   ```

## Configuration

### Environment Parameters

The infrastructure supports three environments: `dev`, `stg`, and `prod`. Configuration is managed through parameter files in the `parameters/` directory.

Key parameters include:
- **Client**: Customer identifier
- **Region**: AWS deployment region
- **VPC CIDR**: Network addressing
- **Database settings**: RDS configuration
- **Connect settings**: Instance configuration

### Parameter Files
- `parameters/dev.json` - Development environment
- `parameters/stg.json` - Staging environment  
- `parameters/prod.json` - Production environment

## Infrastructure Components

### VPC (vpc.yaml)
- Multi-AZ deployment across 3 availability zones
- Public subnets for NAT gateways and load balancers
- Private subnets for application resources
- Internet and NAT gateways for connectivity

### RDS (rds.yaml)
- PostgreSQL 16.4 database
- Multi-AZ for production environments
- Automated backups and maintenance windows
- Performance Insights enabled
- Encryption at rest with KMS

### Lambda Functions (lambda.yaml)
- Contact center core API
- Command center functionality
- Outbound contact utilities
- Post-call processing
- Voice mail processing
- Holiday/emergency messaging
- Queue experience management

### API Gateway (api_gateway.yaml)
- Private API endpoints
- Comprehensive resource structure
- JWT authorization
- Integration with Lambda functions
- Support for insurance core operations

### Amazon Connect (connect.yaml)
- Contact center instance
- Default queues and routing profiles
- Hours of operation
- Contact flows
- Storage configuration

### Security (iam.yaml)
- Lambda execution roles
- Cross-service permissions
- Least privilege access
- Service-specific policies

## Monitoring & Logging

### CloudWatch Integration
- Lambda function logs
- API Gateway access logs
- Connect contact flow logs
- RDS performance monitoring

### Performance Insights
- Database query performance
- Resource utilization metrics
- Historical performance data

## Security Features

### Network Security
- Private subnets for sensitive resources
- VPC endpoints for AWS service access
- Security groups with minimal required access
- NAT gateways for outbound connectivity

### Data Protection
- Encryption at rest for RDS and S3
- KMS key management
- Secrets Manager for database credentials
- IAM roles and policies

### Access Control
- Resource-based policies
- Cross-account access controls
- API Gateway authorization
- Connect security profiles

## Maintenance

### Backup Strategy
- RDS automated backups (7-14 days retention)
- Manual RDS snapshots
- S3 lifecycle policies
- Cross-region replication options

### Updates & Patches
- Automated minor version updates for RDS
- Lambda runtime updates
- Security patch management
- Rolling updates for multi-AZ resources

## Troubleshooting

### Common Issues

#### Stack Deployment Failures
1. Check IAM permissions
2. Verify S3 bucket access
3. Confirm service limits
4. Review CloudFormation events

#### Connectivity Issues
1. Verify security group rules
2. Check VPC endpoint configurations
3. Confirm route table entries
4. Test DNS resolution

#### Performance Issues
1. Monitor CloudWatch metrics
2. Review Performance Insights
3. Check Lambda timeout settings
4. Analyze API Gateway logs

### Debugging Tools
- CloudFormation drift detection
- AWS Config compliance checking
- CloudTrail for API auditing
- X-Ray for distributed tracing

## Cost Optimization

### Production vs Development
- Smaller instance sizes for non-prod
- Reduced backup retention
- Single-AZ deployments for dev/test
- Reserved instances for production

### Resource Optimization
- S3 lifecycle policies
- Lambda memory optimization
- RDS instance right-sizing
- API Gateway caching

## Support

For technical support and questions:
1. Review CloudFormation events and logs
2. Check AWS service health dashboard
3. Consult AWS documentation
4. Contact your AWS solutions architect

## License

This infrastructure code is proprietary and confidential.
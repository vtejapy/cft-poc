# AWS Infrastructure Docker Deployment

This Docker image automatically provisions all AWS resources shown in your architecture diagram using AWS CDK.

## Architecture Components

The infrastructure includes:
- **AWS WAF** - Web Application Firewall for CloudFront
- **CloudFront** - CDN for static content and API caching
- **S3 Buckets** - For UI hosting and document storage
- **API Gateway** - RESTful API endpoints
- **Lambda Functions** - Serverless compute for:
  - Main processing logic
  - Bedrock AI integration
  - Textract document processing
  - SES email sending
- **DynamoDB Tables** - NoSQL databases for customer data and sessions
- **SES** - Email service configuration
- **Bedrock** - AI/ML service integration
- **Textract** - Document analysis service

## Prerequisites

1. AWS Account with appropriate permissions
2. Docker installed on your machine
3. AWS Access Key ID and Secret Access Key

## Directory Structure

```
.
├── Dockerfile
├── README.md
└── cdk-app/
    ├── package.json
    ├── tsconfig.json
    ├── cdk.json
    ├── app.ts
    └── lib/
        └── serverless-stack.ts
```

## Building the Docker Image

```bash
docker build -t aws-infrastructure-deployer .
```

## Running the Deployment

```bash
docker run -it \
  -e AWS_ACCESS_KEY_ID=your_access_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret_key \
  -e AWS_REGION=us-east-1 \
  aws-infrastructure-deployer
```

## Environment Variables

- `AWS_ACCESS_KEY_ID` (required): Your AWS access key
- `AWS_SECRET_ACCESS_KEY` (required): Your AWS secret key
- `AWS_REGION` (optional): AWS region (defaults to us-east-1)

## What Happens During Deployment

1. The Docker container starts and validates AWS credentials
2. CDK bootstraps your AWS account (first-time setup)
3. All resources are created in the following order:
   - S3 buckets
   - DynamoDB tables
   - Lambda functions with appropriate IAM roles
   - API Gateway with endpoints
   - WAF rules
   - CloudFront distribution
   - SES configuration

## Post-Deployment Steps

After successful deployment, you'll receive:
- CloudFront URL for accessing your application
- API Gateway endpoint URL
- S3 bucket names

## Customization

To modify the infrastructure:

1. Edit `cdk-app/lib/serverless-stack.ts`
2. Update Lambda function code
3. Modify resource configurations
4. Rebuild the Docker image

## Cleanup

To destroy all created resources:

```bash
docker run -it \
  -e AWS_ACCESS_KEY_ID=your_access_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret_key \
  -e AWS_REGION=us-east-1 \
  aws-infrastructure-deployer \
  cdk destroy --all
```

## Security Considerations

- Never commit AWS credentials to version control
- Use IAM roles with least privilege principle
- Consider using AWS Secrets Manager for sensitive data
- Enable CloudTrail for audit logging
- Configure WAF rules according to your security requirements

## Cost Optimization

This infrastructure uses several AWS services that may incur costs:
- Lambda: Pay per invocation
- DynamoDB: Pay per request mode
- S3: Storage and transfer costs
- CloudFront: Data transfer costs
- API Gateway: Per request pricing
- Textract and Bedrock: Per API call

Monitor your AWS billing dashboard regularly.

## Troubleshooting

If deployment fails:
1. Check AWS credentials are valid
2. Ensure your account has necessary permissions
3. Verify AWS service limits haven't been reached
4. Check CloudFormation console for detailed error messages
5. Review Docker container logs

## Support

For issues or questions:
1. Check AWS CDK documentation
2. Review CloudFormation stack events
3. Consult AWS service documentation
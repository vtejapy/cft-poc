# CloudFormation Infrastructure Deployment

This repository contains CloudFormation templates converted from Terraform configuration for deploying AWS infrastructure across multiple environments.

## 📁 Project Structure

```
├── cloudformation/
│   ├── main.yaml              # Master stack template
│   ├── parameters/            # Environment-specific parameters
│   │   ├── dev.json          # Development environment
│   │   ├── stg.json          # Staging environment
│   │   └── prod.json         # Production environment
│   └── templates/
│       ├── parameters.yaml    # Common parameters template
│       ├── vpc.yaml          # VPC infrastructure
│       └── s3.yaml           # S3 buckets
├── .github/workflows/
│   └── cloudformation-deploy.yaml  # GitHub Actions workflow
└── README.md
```


## 🚀 GitHub Actions Workflow

The workflow supports:

### **Change Preview (like `terraform plan`)**
- Automatically runs on pull requests
- Creates CloudFormation change sets
- Shows exactly what resources will be created/modified/deleted
- Comments on PRs with change summary

### **Deployment**
- Deploys on push to main/develop branches
- Manual deployment via workflow dispatch
- Environment-specific deployments (dev/stg/prod)

### **Destruction**
- Manual stack deletion via workflow dispatch
- Includes confirmation steps

## 📋 Workflow Features

### 1. **Change Preview**
```yaml
# Triggered on PR or manual dispatch with action=plan
- Creates CloudFormation change sets
- Shows resource changes in table format
- Comments on PRs with change details
- No actual deployment happens
```

### 2. **Validation**
```yaml
- Validates all CloudFormation templates
- Checks syntax and structure
- Runs before any deployment
```

### 3. **Template Management**
```yaml
- Uploads templates to S3 bucket
- Enables versioning
- Manages template lifecycle
```

### 4. **Deployment**
```yaml
- Deploys using CloudFormation nested stacks
- Handles dependencies between stacks
- Shows stack outputs after deployment
```

## 🔧 Usage

### Environment-Specific Parameters
Each environment has its own JSON parameter file:

**Development (`dev.json`)**:
- VPC CIDR: 10.113.0.0/16
- RDS Instance: db.t3.medium
- Lambda Memory: 128MB
- Smaller resource sizes for cost optimization

**Staging (`stg.json`)**:
- VPC CIDR: 10.114.0.0/16
- RDS Instance: db.t3.large
- Lambda Memory: 256MB
- Medium resource sizes for testing

**Production (`prod.json`)**:
- VPC CIDR: 10.115.0.0/16
- RDS Instance: db.r5.xlarge
- Lambda Memory: 512MB
- Full production resource sizes

### Manual Deployment
1. Go to Actions tab in GitHub
2. Select "CloudFormation Deployment"
3. Click "Run workflow"
4. Choose:
   - **Environment**: dev/stg/prod (uses corresponding JSON file)
   - **Action**: plan/deploy/destroy

### Automatic Deployment
- **Push to main**: Deploys to prod using `prod.json`
- **Push to develop**: Deploys to dev using `dev.json`
- **Pull Request**: Shows change preview using `dev.json`

## 🏗️ Infrastructure Components

### Parameters Stack
- Common parameters shared across all stacks
- Environment variables
- Resource naming conventions

### VPC Stack
- VPC with public and private subnets
- Internet Gateway and NAT Gateway
- Route tables and associations
- VPC endpoints for S3

### S3 Stack
- Multiple S3 buckets for different purposes:
  - Recordings and transcripts
  - Exported reports
  - Screen recordings
  - Voice mail
  - Command center
  - Lex bot grammar
  - Bucket logging
  - Contact evaluation
  - CC admin tool

## 📊 Change Preview Example

When you create a pull request, the workflow will:

1. **Generate Change Set**
   ```
   📋 Change Set Details:
   ====================
   Action | LogicalResourceId | ResourceType | Replacement
   CREATE | VPC              | AWS::EC2::VPC | N/A
   CREATE | PublicSubnet1    | AWS::EC2::Subnet | N/A
   ```

2. **Comment on PR**
   ```markdown
   ## 🔍 CloudFormation Change Preview
   
   **Environment:** dev
   **Stack:** infrastructure-dev
   
   ### Changes to be applied:
   - CREATE: VPC (AWS::EC2::VPC)
   - CREATE: PublicSubnet1 (AWS::EC2::Subnet)
   ```

## 🔐 Required Secrets

Set these in your GitHub repository secrets:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

## 🎯 Environment Configuration

The workflow automatically determines the environment:
- **main branch**: prod environment
- **develop branch**: dev environment
- **Manual dispatch**: user-selected environment

## 📝 Stack Dependencies

1. **Parameters Stack** → Base parameters
2. **VPC Stack** → Depends on Parameters
3. **S3 Stack** → Depends on Parameters + VPC

## 🛠️ Customization

### Adding New Templates
1. Create new template in `cloudformation/templates/`
2. Add to `main.yaml` as new nested stack
3. Update dependencies as needed

### Modifying Parameters
1. **Template Parameters**: Edit `cloudformation/templates/parameters.yaml` to add/modify parameter definitions
2. **Environment Values**: Edit JSON files in `cloudformation/parameters/` to set environment-specific values
3. **Main Template**: Update `cloudformation/main.yaml` to pass parameters to nested stacks

### Environment-Specific Values
Each environment uses its own JSON parameter file:
- `dev.json` for development
- `stg.json` for staging  
- `prod.json` for production

Example parameter structure:
```json
[
  {
    "ParameterKey": "VpcCidr",
    "ParameterValue": "10.113.0.0/16"
  },
  {
    "ParameterKey": "RdsInstanceClass",
    "ParameterValue": "db.t3.medium"
  }
]
```

## 🔄 Workflow Triggers

| Trigger | Action | Environment | Parameter File |
|---------|---------|-------------|---------------|
| Push to main | Deploy | prod | prod.json |
| Push to develop | Deploy | dev | dev.json |
| Pull Request | Plan | dev | dev.json |
| Manual dispatch | User choice | User choice | {environment}.json |

## 📈 Monitoring

The workflow provides:
- Real-time deployment status
- Stack outputs after deployment
- Change set details before deployment
- Error messages for troubleshooting

## 🚨 Important Notes

1. **Change Preview First**: Always review changes before deployment
2. **Environment Protection**: Production deployments require manual approval
3. **Stack Dependencies**: Stacks are deployed in the correct order
4. **Rollback**: CloudFormation provides automatic rollback on failure
5. **Cost Optimization**: Templates include lifecycle policies for S3 buckets
6. **Parameter Files**: Each environment uses its own JSON parameter file for configuration
7. **No Terraform**: All Terraform files have been removed - use CloudFormation exclusively
8. **Environment Isolation**: Each environment has separate VPC CIDRs and resource sizing

# Infrastructure Architecture

## Overview

This document describes the architecture of the contact center infrastructure deployed using CloudFormation nested stacks.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                            AWS Account                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐    ┌──────────────────────────────────┐ │
│  │    Amazon Connect   │    │            VPC                   │ │
│  │                     │    │  ┌─────────┐    ┌─────────────┐  │ │
│  │ • Instance          │    │  │ Private │    │   Public    │  │ │
│  │ • Contact Flows     │◄───┼──┤Subnets  │    │  Subnets    │  │ │
│  │ • Queues            │    │  │         │    │             │  │ │
│  │ • Routing Profiles  │    │  │• Lambda │    │• NAT GW     │  │ │
│  └─────────────────────┘    │  │• RDS    │    │• ALB        │  │ │
│                              │  │• Endpoints   │             │  │ │
│  ┌─────────────────────┐    │  └─────────┘    └─────────────┘  │ │
│  │        S3           │    └──────────────────────────────────┘ │
│  │                     │                                         │
│  │ • Recordings        │    ┌──────────────────────────────────┐ │
│  │ • Transcripts       │    │         Data Layer               │ │
│  │ • Voice Mail        │    │  ┌─────────┐    ┌─────────────┐  │ │
│  │ • Exports           │    │  │   RDS   │    │  DynamoDB   │  │ │
│  └─────────────────────┘    │  │         │    │             │  │ │
│                              │  │PostgreSQL    │Queue Exp DB │  │ │
│  ┌─────────────────────┐    │  │Multi-AZ │    │             │  │ │
│  │    API Gateway      │    │  └─────────┘    └─────────────┘  │ │
│  │                     │    └──────────────────────────────────┘ │
│  │ • REST APIs         │                                         │
│  │ • Private Endpoints │    ┌──────────────────────────────────┐ │
│  │ • Lambda Integration│    │      Processing Layer           │ │
│  └─────────────────────┘    │  ┌─────────┐    ┌─────────────┐  │ │
│                              │  │ Lambda  │    │  Kinesis    │  │ │
│                              │  │         │    │             │  │ │
│                              │  │• Core API    │• Streams    │  │ │
│                              │  │• Post Call   │• Firehose   │  │ │
│                              │  │• Voice Mail  │             │  │ │
│                              │  │• Utilities   │             │  │ │
│                              │  └─────────┘    └─────────────┘  │ │
│                              └──────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Stack Architecture

### 1. Foundation Layer

#### VPC Stack (`vpc.yaml`)
- **Purpose**: Provides network foundation
- **Components**:
  - VPC with custom CIDR
  - 3 Public subnets (Multi-AZ)
  - 3 Private subnets (Multi-AZ)
  - Internet Gateway
  - NAT Gateways (one per AZ)
  - Route tables
- **Dependencies**: None

#### S3 Stack (`s3.yaml`)
- **Purpose**: Object storage for contact center data
- **Components**:
  - Recordings and transcripts bucket
  - Voice mail bucket
  - Exported reports bucket
  - Screen recordings bucket
  - Command center bucket
  - Lifecycle policies
- **Dependencies**: VPC (for VPC endpoint configuration)

### 2. Data Layer

#### RDS Stack (`rds.yaml`)
- **Purpose**: Relational database for application data
- **Components**:
  - PostgreSQL 16.4 instance
  - Multi-AZ for production
  - Parameter group
  - Security group
  - Subnet group
  - Manual snapshot
- **Dependencies**: VPC

#### DynamoDB Stack (`dynamodb.yaml`)
- **Purpose**: NoSQL database for queue experience
- **Components**:
  - Queue experience table
  - Global secondary indexes
  - On-demand billing
- **Dependencies**: VPC

### 3. Security Layer

#### IAM Stack (`iam.yaml`)
- **Purpose**: Access control and permissions
- **Components**:
  - Lambda execution roles
  - Cross-service policies
  - Resource-based permissions
- **Dependencies**: VPC

#### VPC Endpoints Stack (`vpc_endpoints.yaml`)
- **Purpose**: Private connectivity to AWS services
- **Components**:
  - API Gateway endpoints
  - S3 endpoints
  - Secrets Manager endpoints
  - Lambda endpoints
  - DynamoDB endpoints
  - Security groups
- **Dependencies**: VPC

### 4. Integration Layer

#### Kinesis Stack (`kinesis.yaml`)
- **Purpose**: Real-time data streaming
- **Components**:
  - Queue experience stream
  - CTR stream
  - Agent event stream
  - Firehose delivery stream
- **Dependencies**: S3 (for Firehose destination)

#### Lambda Stack (`lambda.yaml`)
- **Purpose**: Business logic and integrations
- **Components**:
  - Contact center core API
  - Command center functionality
  - Post-call processing
  - Voice mail handling
  - Queue experience management
  - Lambda layers
- **Dependencies**: IAM, Kinesis, DynamoDB

### 5. Application Layer

#### API Gateway Stack (`api_gateway.yaml`)
- **Purpose**: RESTful API endpoints
- **Components**:
  - Private REST API
  - Resource hierarchy
  - Method configurations
  - Lambda integrations
  - Request validation
- **Dependencies**: VPC Endpoints, Lambda

#### Connect Stack (`connect.yaml`)
- **Purpose**: Contact center functionality
- **Components**:
  - Connect instance
  - Contact flows
  - Queues and routing profiles
  - Hours of operation
  - Security profiles
- **Dependencies**: S3 (for storage configuration)

#### EventBridge Stack (`event_bridge.yaml`)
- **Purpose**: Event-driven automation
- **Components**:
  - Scheduled rules
  - Lambda targets
- **Dependencies**: Lambda

## Network Architecture

### Subnet Design

```
VPC: 10.113.0.0/16 (dev) | 10.115.0.0/16 (prod)

Public Subnets (NAT, ALB):
├── Public-1a:  10.x.20.0/24
├── Public-1b:  10.x.21.0/24
└── Public-1c:  10.x.22.0/24

Private Subnets (Apps, DB):
├── Private-1a: 10.x.10.0/24
├── Private-1b: 10.x.11.0/24
└── Private-1c: 10.x.12.0/24
```

### Security Groups

```
┌─────────────────┐    ┌─────────────────┐
│   Lambda SG     │────│    RDS SG       │
│ Outbound: All   │    │ Inbound: 5432   │
└─────────────────┘    │ from VPC CIDR   │
                       └─────────────────┘

┌─────────────────┐    ┌─────────────────┐
│ API Gateway SG  │────│  VPC Endpoint   │
│ Inbound: 443    │    │ SGs (Various)   │
│ from VPC        │    │ Inbound: 443    │
└─────────────────┘    └─────────────────┘
```

## Data Flow

### Contact Processing Flow
1. **Inbound Contact** → Amazon Connect
2. **Contact Data** → Lambda (Core API)
3. **Queue Data** → DynamoDB
4. **Recordings** → S3 (via Kinesis Firehose)
5. **Analytics** → Kinesis Streams
6. **Notifications** → EventBridge → Lambda

### API Request Flow
1. **Client Request** → API Gateway
2. **Authorization** → Lambda (JWT)
3. **Business Logic** → Lambda (Core API)
4. **Data Access** → RDS/DynamoDB
5. **Response** → Client

### Voice Mail Flow
1. **Voice Recording** → S3
2. **Processing** → Lambda (Voice Mail)
3. **Notification** → EventBridge
4. **Email/SMS** → Lambda (Notification)

## Scalability Considerations

### Horizontal Scaling
- **Lambda**: Automatic scaling
- **API Gateway**: Built-in scaling
- **DynamoDB**: On-demand scaling
- **Kinesis**: Shard-based scaling

### Vertical Scaling
- **RDS**: Instance size adjustment
- **Lambda**: Memory allocation
- **Connect**: Concurrent call limits

### Multi-AZ Design
- **RDS**: Multi-AZ deployment in prod
- **Subnets**: Distributed across 3 AZs
- **NAT Gateways**: One per AZ

## Security Architecture

### Defense in Depth
1. **Network**: Private subnets, security groups
2. **Access**: IAM roles, least privilege
3. **Data**: Encryption at rest and in transit
4. **API**: Request validation, rate limiting
5. **Monitoring**: CloudTrail, CloudWatch

### Encryption
- **RDS**: Encrypted with KMS
- **S3**: Server-side encryption
- **Lambda**: Environment variables encrypted
- **Secrets**: AWS Secrets Manager

## Monitoring and Observability

### CloudWatch Integration
- **Metrics**: All services emit metrics
- **Logs**: Centralized logging
- **Alarms**: Proactive monitoring
- **Dashboards**: Operational visibility

### Performance Monitoring
- **RDS**: Performance Insights
- **Lambda**: X-Ray tracing
- **API Gateway**: Access logs
- **Connect**: Real-time metrics

## Disaster Recovery

### Backup Strategy
- **RDS**: Automated backups + manual snapshots
- **S3**: Cross-region replication option
- **DynamoDB**: Point-in-time recovery
- **Lambda**: Code in version control

### Recovery Procedures
1. **RDS**: Restore from snapshot
2. **S3**: Restore from backup region
3. **Infrastructure**: Redeploy from CloudFormation
4. **Configuration**: Parameter files in git

## Cost Optimization

### Environment Sizing
- **Dev**: Single AZ, smaller instances
- **Staging**: Reduced capacity
- **Production**: Full Multi-AZ setup

### Resource Optimization
- **Lambda**: Right-sized memory
- **RDS**: Reserved instances for prod
- **S3**: Lifecycle policies
- **API Gateway**: Caching enabled
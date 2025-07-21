import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as wafv2 from 'aws-cdk-lib/aws-wafv2';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as ses from 'aws-cdk-lib/aws-ses';
import { Construct } from 'constructs';

export class ServerlessInfrastructureStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 1. S3 Buckets
    const chatbotUIBucket = new s3.Bucket(this, 'ChatbotUIBucket', {
      bucketName: `chatbot-ui-${this.account}-${this.region}`,
      websiteIndexDocument: 'index.html',
      publicReadAccess: false,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
    });

    const documentsBucket = new s3.Bucket(this, 'DocumentsBucket', {
      bucketName: `documents-${this.account}-${this.region}`,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
    });

    // 2. DynamoDB Tables
    const customerTable = new dynamodb.Table(this, 'CustomerDatabase', {
      tableName: 'CustomerDatabase',
      partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    const sessionsTable = new dynamodb.Table(this, 'SessionsTable', {
      tableName: 'ChatSessions',
      partitionKey: { name: 'sessionId', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    // 3. Lambda Functions
    const bedrockLambda = new lambda.Function(this, 'BedrockLambda', {
      runtime: lambda.Runtime.PYTHON_3_11,
      handler: 'bedrock_handler.handler',
      code: lambda.Code.fromInline(`
import json
import boto3

bedrock = boto3.client('bedrock-runtime')

def handler(event, context):
    # Bedrock integration logic
    return {
        'statusCode': 200,
        'body': json.dumps('Bedrock response')
    }
      `),
      timeout: cdk.Duration.minutes(5),
      memorySize: 512,
    });

    const textractLambda = new lambda.Function(this, 'TextractLambda', {
      runtime: lambda.Runtime.PYTHON_3_11,
      handler: 'textract_handler.handler',
      code: lambda.Code.fromInline(`
import json
import boto3

textract = boto3.client('textract')

def handler(event, context):
    # Textract document processing logic
    return {
        'statusCode': 200,
        'body': json.dumps('Document processed')
    }
      `),
      timeout: cdk.Duration.minutes(5),
      memorySize: 512,
    });

    const sesLambda = new lambda.Function(this, 'SESLambda', {
      runtime: lambda.Runtime.PYTHON_3_11,
      handler: 'ses_handler.handler',
      code: lambda.Code.fromInline(`
import json
import boto3

ses = boto3.client('ses')

def handler(event, context):
    # SES email sending logic
    return {
        'statusCode': 200,
        'body': json.dumps('Email sent')
    }
      `),
      timeout: cdk.Duration.seconds(30),
      environment: {
        'SES_REGION': this.region,
      },
    });

    const mainLambda = new lambda.Function(this, 'MainProcessingLambda', {
      runtime: lambda.Runtime.PYTHON_3_11,
      handler: 'main_handler.handler',
      code: lambda.Code.fromInline(`
import json
import boto3

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    # Main processing logic
    return {
        'statusCode': 200,
        'body': json.dumps('Processing complete')
    }
      `),
      timeout: cdk.Duration.minutes(3),
      environment: {
        'CUSTOMER_TABLE': customerTable.tableName,
        'SESSIONS_TABLE': sessionsTable.tableName,
      },
    });

    // Grant permissions
    customerTable.grantReadWriteData(mainLambda);
    sessionsTable.grantReadWriteData(mainLambda);
    documentsBucket.grantReadWrite(textractLambda);
    
    // Grant Bedrock permissions
    bedrockLambda.addToRolePolicy(new iam.PolicyStatement({
      actions: ['bedrock:InvokeModel'],
      resources: ['*'],
    }));

    // Grant Textract permissions
    textractLambda.addToRolePolicy(new iam.PolicyStatement({
      actions: ['textract:*'],
      resources: ['*'],
    }));

    // Grant SES permissions
    sesLambda.addToRolePolicy(new iam.PolicyStatement({
      actions: ['ses:SendEmail', 'ses:SendRawEmail'],
      resources: ['*'],
    }));

    // 4. API Gateway
    const api = new apigateway.RestApi(this, 'ChatbotAPI', {
      restApiName: 'Chatbot Service',
      description: 'API for chatbot application',
      deployOptions: {
        stageName: 'prod',
      },
      defaultCorsPreflightOptions: {
        allowOrigins: apigateway.Cors.ALL_ORIGINS,
        allowMethods: apigateway.Cors.ALL_METHODS,
      },
    });

    // API Resources and Methods
    const chat = api.root.addResource('chat');
    chat.addMethod('POST', new apigateway.LambdaIntegration(mainLambda));

    const documents = api.root.addResource('documents');
    documents.addMethod('POST', new apigateway.LambdaIntegration(textractLambda));

    const email = api.root.addResource('email');
    email.addMethod('POST', new apigateway.LambdaIntegration(sesLambda));

    const bedrock = api.root.addResource('bedrock');
    bedrock.addMethod('POST', new apigateway.LambdaIntegration(bedrockLambda));

    // 5. WAF Web ACL
    const webAcl = new wafv2.CfnWebACL(this, 'ChatbotWAF', {
      scope: 'CLOUDFRONT',
      defaultAction: { allow: {} },
      rules: [
        {
          name: 'RateLimitRule',
          priority: 1,
          statement: {
            rateBasedStatement: {
              limit: 2000,
              aggregateKeyType: 'IP',
            },
          },
          action: { block: {} },
          visibilityConfig: {
            sampledRequestsEnabled: true,
            cloudWatchMetricsEnabled: true,
            metricName: 'RateLimitRule',
          },
        },
      ],
      visibilityConfig: {
        sampledRequestsEnabled: true,
        cloudWatchMetricsEnabled: true,
        metricName: 'ChatbotWAF',
      },
    });

    // 6. CloudFront Distribution
    const distribution = new cloudfront.Distribution(this, 'ChatbotDistribution', {
      defaultBehavior: {
        origin: new origins.S3Origin(chatbotUIBucket),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
      },
      additionalBehaviors: {
        '/api/*': {
          origin: new origins.RestApiOrigin(api),
          viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.HTTPS_ONLY,
          allowedMethods: cloudfront.AllowedMethods.ALLOW_ALL,
          cachePolicy: cloudfront.CachePolicy.CACHING_DISABLED,
        },
      },
      webAclId: webAcl.attrArn,
    });

    // 7. SES Configuration (Domain Identity)
    new ses.EmailIdentity(this, 'EmailIdentity', {
      identity: ses.Identity.domain('example.com'), // Replace with your domain
    });

    // Outputs
    new cdk.CfnOutput(this, 'CloudFrontURL', {
      value: distribution.distributionDomainName,
      description: 'CloudFront Distribution URL',
    });

    new cdk.CfnOutput(this, 'APIGatewayURL', {
      value: api.url,
      description: 'API Gateway URL',
    });

    new cdk.CfnOutput(this, 'S3BucketName', {
      value: chatbotUIBucket.bucketName,
      description: 'S3 Bucket for UI',
    });
  }
}
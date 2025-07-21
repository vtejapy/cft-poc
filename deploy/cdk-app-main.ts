#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { ServerlessInfrastructureStack } from './lib/serverless-stack';

const app = new cdk.App();

new ServerlessInfrastructureStack(app, 'ServerlessInfrastructureStack', {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION || 'us-east-1',
  },
  description: 'Serverless application infrastructure with WAF, CloudFront, S3, API Gateway, Lambda, DynamoDB, SES, Textract, and Bedrock',
});
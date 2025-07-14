kinei

```
################################################
##         queue_exp_kinesis_stream            ##
################################################
resource "aws_kinesis_stream" "queue_exp_kinesis_stream" {
  name             = "queue-exp-kinesis-stream-${var.client}-${var.region}-${var.environment}"
  shard_count      = 2
  retention_period = 48
  encryption_type  = "KMS"
  kms_key_id       = "alias/aws/kinesis"
  shard_level_metrics = [
    "IncomingBytes",
    "IncomingRecords",
    "OutgoingBytes",
    "OutgoingRecords",
  ]
  tags = merge(local.common_tags, {
    Name = "queue-exp-kinesis-stream-${var.client}-${var.region}-${var.environment}"
  })

}


################################################
##             CTR_kinesis_stream             ##
################################################
resource "aws_kinesis_stream" "CTR_kinesis_stream" {
  name             = "CTR-kinesis-streams-${var.client}-${var.region}-${var.environment}"
  shard_count      = var.shard_count
  retention_period = var.retention_period
  encryption_type  = "KMS"
  kms_key_id       = "alias/aws/kinesis"
  shard_level_metrics = [
    "IncomingBytes",
    "IncomingRecords",
    "OutgoingBytes",
    "OutgoingRecords",
  ]
  tags = merge(local.common_tags, {
    Name = "CTR-kinesis-streams-${var.client}-${var.region}-${var.environment}"
  })
}

################################################
##         agent-event-kinesis-stream         ##
################################################
resource "aws_kinesis_stream" "agent_event_kinesis_stream" {
  name             = "agent-event-kinesis-streams-${var.client}-${var.region}-${var.environment}"
  shard_count      = var.shard_count
  retention_period = var.retention_period
  encryption_type  = "KMS"
  kms_key_id       = "alias/aws/kinesis"
  shard_level_metrics = [
    "IncomingBytes",
    "IncomingRecords",
    "OutgoingBytes",
    "OutgoingRecords",
  ]
  tags = merge(local.common_tags, {
    Name = "agent-event-kinesis-streams-${var.client}-${var.region}-${var.environment}"
  })
}

# IAM Role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "zeta-sparrow-firehose-delivery-role-${var.region}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM Policy for Firehose
resource "aws_iam_role_policy" "firehose_policy" {
  name = "zeta-sparrow-firehose-s3-policy-${var.region}-${var.environment}"
  role = aws_iam_role.firehose_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.firehose_bucket.arn}",
        "${aws_s3_bucket.firehose_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_stream.firehose_log_stream.arn}"
      ]
    }
  ]
}
EOF
}

# CloudWatch Logs for Firehose
resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name = "/aws/kinesisfirehose/zeta-sparrow-firehose-stream"
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "zeta-sparrow-S3Delivery-${var.region}-${var.environment}"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "s3_stream" {
  name        = "zeta-sparrow-firehose-stream-${var.region}-${var.environment}"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.firehose_bucket.arn
    buffer_size        = 128
    buffer_interval    = 300
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }


    s3_backup_mode = "Disabled"
  }

  tags = merge(local.common_tags, {
    Name = "zeta-sparrow-firehose-stream-${var.region}-${var.environment}"
  })
}
 
```
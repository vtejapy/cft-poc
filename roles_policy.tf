##roletf

```
# command-center-api

#command-center-lambda

resource "aws_iam_role" "command_center_lambda_role" {
  name = "command-center-lambda-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "CCenterLambdaAccess"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "command-center-lambda-role-${var.client}-${var.region}-${var.environment}"
  })

}

  resource "aws_iam_policy" "command_center_policy" {
    name        = "command-center-policy-${var.client}-${var.region}-${var.environment}"
    path        = "/"
    description = "IAM policy for command_center service"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "connect:ListPhoneNumbers",
            "connect:DescribeQueue",
            "secretsmanager:GetSecretValue",
            "connect:SearchQueues",
            "secretsmanager:DescribeSecret",
            "connect:ListUsers",
            "rds:DescribeDBInstances",
            "connect:DescribeUser",
            "connect:SearchUsers",
            "connect:ListContactFlows",
            "apigateway:GET"
          ],
          "Resource" : [
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:db-*",
            "${aws_connect_instance.genpact_poc.arn}/contact-flow/*",
            "${aws_connect_instance.genpact_poc.arn}/phone-number/*",
            "${aws_connect_instance.genpact_poc.arn}/queue/*",
            "${aws_connect_instance.genpact_poc.arn}",
            "${aws_connect_instance.genpact_poc.arn}/agent/*",
            "arn:aws:apigateway:${var.region}:${data.aws_caller_identity.current.account_id}:/apis*",
            #"arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.rds_secret_name}-*"
            "${aws_db_instance.postgres_rds.master_user_secret[0].secret_arn}"
          ]
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "connect:ListQueues",
            "apigateway:GET"
          ],
          "Resource" : ["arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:/apis*",
          "${aws_connect_instance.genpact_poc.arn}/queue/*"]
          "Effect" : "Allow"
        }
      ]
    })


    tags = merge(local.common_tags, {
      name = "command-center-policy-${var.client}-${var.region}-${var.environment}"
    })
  }

  resource "aws_iam_role_policy_attachment" "command_center_policy_attach" {
    role       = aws_iam_role.command_center_lambda_role.name
    policy_arn = aws_iam_policy.command_center_policy.arn
  }

  resource "aws_iam_role_policy_attachment" "command_center_policy_logging" {
    role       = aws_iam_role.command_center_lambda_role.name
    policy_arn = aws_iam_policy.common_logging_policy.arn
  }

  resource "aws_iam_role_policy_attachment" "command_center_lambda_VPCAccessExecutionRole" {
    role       = aws_iam_role.command_center_lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  }

## contact-center-core-api

resource "aws_iam_role" "contact_center_core_api_lambda_role" {
  name = "contact-center-core-api-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "commandcenterLambda"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "contact-center-core-api-role-${var.client}-${var.region}-${var.environment}"
  })

}


resource "aws_iam_policy" "contact_center_core_api_policy" {
  name        = "command-center-rest-api-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for command-center"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "commandCenter",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket",
          "kms:Describe*",
          "s3:PutObject",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "lambda:InvokeFunction",
          "lambda:InvokeAsync"

        ]
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.exported_reports.id}",
          "arn:aws:s3:::${aws_s3_bucket.exported_reports.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.recordings_and_transcripts.id}",
          "arn:aws:s3:::${aws_s3_bucket.recordings_and_transcripts.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.screen_recordings.id}",
          "arn:aws:s3:::${aws_s3_bucket.screen_recordings.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.ccenter.id}",
          "arn:aws:s3:::${aws_s3_bucket.ccenter.id}/*",
          "${aws_db_instance.postgres_rds.master_user_secret[0].secret_arn}",
          #"arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${data.aws_secretsmanager_secret.rds.name}-*",
          "${aws_lambda_function.outbound_contact_precheck_utility_lambda.arn}"
        ]
      },
      #   {
      #     "Sid" : "commandCenterAPI",
      #     "Effect" : "Allow",
      #     "Action" : [
      #       "secretsmanager:GetSecretValue",
      #       "secretsmanager:DescribeSecret"

      #     ]
      #     "Resource" : [
      #       "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${data.aws_secretsmanager_secret.rds.name}-*"


      #     ]
      #   },
      {
        "Sid" : "CommandCenterInvoke",
        "Effect" : "Allow",
        "Action" : [
          "kms:Describe*",
        ]
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.exported_reports.id}",
          "arn:aws:s3:::${aws_s3_bucket.exported_reports.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.recordings_and_transcripts.id}",
          "arn:aws:s3:::${aws_s3_bucket.recordings_and_transcripts.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.screen_recordings.id}",
          "arn:aws:s3:::${aws_s3_bucket.screen_recordings.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.ccenter.id}",
          "arn:aws:s3:::${aws_s3_bucket.ccenter.id}/*",
        ]
      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "contact_center_core_api-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "contact_center_core_api_lambda_policy_logging" {
  role       = aws_iam_role.contact_center_core_api_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "contact_center_core_api_lambda_VPCAccess" {
  role       = aws_iam_role.contact_center_core_api_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "contact_center_core_api_policy_attach" {
  role       = aws_iam_role.contact_center_core_api_lambda_role.name
  policy_arn = aws_iam_policy.contact_center_core_api_policy.arn
}


## kvs-processor

#ivr
resource "aws_iam_role" "kvs_recording_processor_lambda_role" {
  name = "kvs-recording-processor-lambda-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "kvs-recording-processor-lambda-role-${var.client}-${var.region}-${var.environment}"
  })

}

resource "aws_iam_policy" "kvs_recording_processor_policy" {
  name        = "kvs-recording-processor-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for ivr recording processor lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "s3andKinesis",
        "Effect" : "Allow",
        "Action" : [
          "kinesis:GetShardIterator",
          "kinesis:Get*",
          "kinesisvideo:Describe*",
          "kinesisvideo:Get*",
          "kinesisvideo:List*",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "kinesis:DescribeStream",
          "s3-object-lambda:GetObject",
          "transcribe:GetTranscriptionJob",

        ]
        "Resource" : [
          "${aws_kinesis_stream.CTR_kinesis_stream.arn}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}/*",
          "arn:aws:kinesisvideo:${var.region}:${data.aws_caller_identity.current.account_id}:stream/*",
          "arn:aws:s3-object-lambda:${var.region}:${data.aws_caller_identity.current.account_id}:accesspoint/*",
          "arn:aws:transcribe:${var.region}:${data.aws_caller_identity.current.account_id}:transcription-job/*"
        ]
      },
      {
        "Sid" : "s3accesspoint",
        "Effect" : "Allow",
        "Action" : "s3-object-lambda:GetObject",
        "Resource" : "arn:aws:s3-object-lambda:${var.region}:${data.aws_caller_identity.current.account_id}:accesspoint/*"
      },
      {
        "Sid" : "transcribeAccess",
        "Effect" : "Allow",
        "Action" : [
          "comprehend:DetectSentiment",
          "transcribe:StartTranscriptionJob",
          "transcribe:ListTranscriptionJobs"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "KinesisStreamAccess",
        "Effect" : "Allow",
        "Action" : "kinesisvideo:List*",
        "Resource" : "arn:aws:kinesisvideo:${var.region}:${data.aws_caller_identity.current.account_id}:stream/*"
      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "kvs-recording-processor-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "attach_kvs_recording_processor_policy" {
  role       = aws_iam_role.kvs_recording_processor_lambda_role.name
  policy_arn = aws_iam_policy.kvs_recording_processor_policy.arn
}

resource "aws_iam_role_policy_attachment" "kvs_recording_processor_lambda_policy_logging" {
  role       = aws_iam_role.kvs_recording_processor_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "kvs_recording_processor_lambda_VPCAccess" {
  role       = aws_iam_role.kvs_recording_processor_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


## ContactLens-Evaluation-loader
resource "aws_iam_role" "contactLens_evaluation_loader_lambda_role" {
  name = "contactLens-eval-loader-lambda-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "PostCtrLambdaAccess"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "contactLens-evaluation-loader-lambda-role-${var.client}-${var.region}-${var.environment}"
  })

}

resource "aws_iam_policy" "contactLens_evaluation_policy" {
  name        = "contactLens-evaluation-loader-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for contactLens-evaluation-loader"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "rds:ModifyDBInstance",
          "rds:DescribeDBInstances",
          "rds:CreateDBSnapshot",
          "rds:DescribeDBSnapshots",
          "rds-db:connect",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"

        ],
        "Resource" : [
          "${aws_db_instance.postgres_rds.arn}",
          "arn:aws:s3:::${aws_s3_bucket.recordings_and_transcripts.id}",
          "arn:aws:s3:::${aws_s3_bucket.recordings_and_transcripts.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.exported_reports.id}",
          "arn:aws:s3:::${aws_s3_bucket.exported_reports.id}/*",
          "${aws_db_instance.postgres_rds.master_user_secret[0].secret_arn}"
          #"arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${data.aws_secretsmanager_secret.rds.name}-*",
          #"arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:EDH-*"
        ],
        "Effect" : "Allow"
      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "contactLens-evaluation-loader-policy-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_iam_role_policy_attachment" "contactLens_evaluation_policy_attach" {
  role       = aws_iam_role.contactLens_evaluation_loader_lambda_role.name
  policy_arn = aws_iam_policy.contactLens_evaluation_policy.arn
}

resource "aws_iam_role_policy_attachment" "post_ctr_edh_policy_logging" {
  role       = aws_iam_role.contactLens_evaluation_loader_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "contactLens_evaluation_VPCAccessExecutionRole" {
  role       = aws_iam_role.contactLens_evaluation_loader_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

## outbound-contact-precheck-utility

resource "aws_iam_role" "outbound_contact_precheck_utility_lambda_role" {
  name = "outbound-contact-precheck-utility-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "outbound-contact-precheck-utility-role-${var.client}-${var.region}-${var.environment}"
  })

}


resource "aws_iam_policy" "outbound_contact_precheck_utility_policy" {
  name        = "outbound-contact-precheck-utility-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for outbound-contact-precheck-utility"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "911Disconnect",
        "Effect" : "Allow",
        "Action" : [
          "connect:ListPhoneNumbers",
          "connect:DescribeQueue",
          "connect:SearchQueues",
          "connect:ListUsers",
          "connect:DescribeUser",
          "connect:SearchUsers",
          "connect:ListContactFlows",
          "connect:StopContact",
        ]
        "Resource" : [
          "${aws_connect_instance.genpact_poc.arn}/contact/*",
          "${aws_connect_instance.genpact_poc.arn}/agent/*",
          "${aws_connect_instance.genpact_poc.arn}/queue/*",
          "${aws_connect_instance.genpact_poc.arn}/phone-number/*",
          "${aws_connect_instance.genpact_poc.arn}/contact-flow/*",
          "${aws_connect_instance.genpact_poc.arn}",
        ]
      },
      #   {
      #     "Sid" : "LambdaInvoke",
      #     "Effect" : "Allow",
      #     "Action" : [
      #       "lambda:InvokeFunction",
      #       "lambda:InvokeAsync",
      #     ]
      #     "Resource" : [
      #       "${aws_lambda_function.amazon_connect_notification_lambda.arn}",
      #     ]
      #   },
      {
        "Sid" : "ConnectLIstqueues",
        "Effect" : "Allow",
        "Action" : [
          "connect:ListQueues",
        ]
        "Resource" : [
          "${aws_connect_instance.genpact_poc.arn}/queue/*",
        ]
      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "outbound-contact-precheck-utility-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "outbound_contact_precheck_utility_policy_attach" {
  role       = aws_iam_role.outbound_contact_precheck_utility_lambda_role.name
  policy_arn = aws_iam_policy.outbound_contact_precheck_utility_policy.arn
}

resource "aws_iam_role_policy_attachment" "outbound_contact_precheck_utility_lambda_policy_logging" {
  role       = aws_iam_role.outbound_contact_precheck_utility_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}
resource "aws_iam_role_policy_attachment" "outbound_contact_precheck_utility_lambda_VPCAccess" {
  role       = aws_iam_role.outbound_contact_precheck_utility_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# ### cloudwatch-alarm-processor

resource "aws_iam_role" "cloudwatch_alarm_processor_lambda_role" {
  name = "cloudwatch-alarm-processor-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "cloudwatch-alarm-processor-role-${var.client}-${var.region}-${var.environment}"
  })

}
resource "aws_iam_policy" "cloudwatch_alarm_processor_policy" {
  name        = "cloudwatch-alarm-processor-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for cloudwatch_alarm_processor"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "cloudwatchMetricsAlarm",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
        ]
        "Resource" : [

          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:SMTP-*"

        ]
      }
    ]
  })

  tags = merge(local.common_tags, {
    name = "cloudwatch-alarm-processor-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_alarm_processor_policy" {
  role       = aws_iam_role.cloudwatch_alarm_processor_lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_alarm_processor_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_alarm_processor_policy_logging" {
  role       = aws_iam_role.cloudwatch_alarm_processor_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_alarm_processor_lambda_VPCAccess" {
  role       = aws_iam_role.cloudwatch_alarm_processor_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

## queue-experience-utility


resource "aws_iam_role" "queue_experience_utility_lambda_role" {
  name = "queue_experience_utility_lambda_role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "QueueLambdaAccess"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "queue_experience_utility_lambda_role-${var.client}-${var.region}-${var.environment}"
  })

}


# IAM Policy Creation: Allow Cloudwatch Logging

resource "aws_iam_policy" "common_logging_policy" {
  name        = "common-logging-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for queue_exp logging from a lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:logs:*",
        "Effect" : "Allow"
      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "common-logging-policy-${var.client}-${var.region}-${var.environment}"
  })
}

# IAM Policy Creation: Allow feed to cqa Kinesis Processing

resource "aws_iam_policy" "queue_exp_event_processing" {
  name        = "queue-exp-eventbridge-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for event bridge processing"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "connect:DescribeQueue",
          "connect:DescribeHoursOfOperation",
          "connect:ListUsers",
          "connect:AssociateQueueQuickConnects",
          "connect:CreateQuickConnect",
          "connect:SearchUsers",
          "connect:SearchQueues",
          "connect:DescribeUser",
          "connect:DescribeQuickConnect",
          "connect:ListQueues",
          "connect:ListContactFlows",
          "connect:DescribeContactFlow",
          "connect:SearchContactFlows",
          "connect:ListQuickConnects",
          "connect:DeleteQuickConnect"
        ],
        "Resource" = ["${aws_connect_instance.genpact_poc.arn}/queue/*",
          "${aws_connect_instance.genpact_poc.arn}/operating-hours/*",
          "${aws_connect_instance.genpact_poc.arn}/transfer-destination/*",
          "${aws_connect_instance.genpact_poc.arn}/quick-connect/*",
          "${aws_connect_instance.genpact_poc.arn}/agent/*",
          "${aws_connect_instance.genpact_poc.arn}/contact-flow/*",
          "${aws_connect_instance.genpact_poc.arn}"
        ]
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:GetRecords",
        ],
        "Resource" = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/*"
        "Effect" : "Allow"

      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "queue-exp-eventbridge-policy-${var.client}-${var.region}-${var.environment}"
  })
}

# Attach IAM Policies to Roles

resource "aws_iam_role_policy_attachment" "queue_exp_logs" {
  role       = aws_iam_role.queue_experience_utility_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "queue_exp_events" {
  role       = aws_iam_role.queue_experience_utility_lambda_role.name
  policy_arn = aws_iam_policy.queue_exp_event_processing.arn
}

resource "aws_iam_role_policy_attachment" "queue_exp_lambda_VPCAccessExecutionRole" {
  role       = aws_iam_role.queue_experience_utility_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "queue_exp_lambda_kinesisExecutionRole" {
  role       = aws_iam_role.queue_experience_utility_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

#### contact-prechecks-utility


resource "aws_iam_role" "contact_prechecks_utility_lambda_role" {
  name = "contact_prechecks_utility_lambda_role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "HolidaylambdaAccess"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "contact_prechecks_utility_lambda_role-${var.client}-${var.region}-${var.environment}"
  })

}

resource "aws_iam_policy" "contact_prechecks_utility_lambda_policy" {
  name        = "contact_prechecks_utility_lambda-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for contact_prechecks_utility_lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "apigateway:GET",
          "apigateway:POST",
          "execute-api:Invoke",
          "execute-api:ManageConnections"
        ],
        "Resource" : [
          "arn:aws:apigateway:${var.region}::/restapis/${aws_api_gateway_rest_api.connect_core_api.id}/*",
          "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.connect_core_api.id}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
  tags = merge(local.common_tags, {
    Name = "contact_prechecks_utility_lambda-policy-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_iam_role_policy_attachment" "contact_prechecks_utility_policy_attach" {
  role       = aws_iam_role.contact_prechecks_utility_lambda_role.name
  policy_arn = aws_iam_policy.contact_prechecks_utility_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "contact_prechecks_utility_policy_logging" {
  role       = aws_iam_role.contact_prechecks_utility_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "contact_prechecks_utility_lambda_VPCAccessExecutionRole" {
  role       = aws_iam_role.contact_prechecks_utility_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

## ctr-processor

resource "aws_iam_role" "ctr_processor_lambda_role" {
  name = "ctr_processor_lambda_role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "VoicemailLambdaAcces"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "ctr_processor_lambda_role-${var.client}-${var.region}-${var.environment}"
  })

}


resource "aws_iam_policy" "ctr_processor_lambda_policy" {
  name        = "voice-mail-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for voice mail access for a lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "transcribe:GetTranscriptionJobs",
          "transcribe:GetTranscriptionJobs",
          "kinesis:GetShardIterator",
          "kinesis:Get*",
          "kinesisvideo:Describe*",
          "kinesisvideo:Get*",
          "kinesisvideo:List*",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "lambda:InvokeFunction",
          "lambda:InvokeAsync",
          "execute-api:Invoke",
          "transcribe:StartTranscriptionJob",
          "kinesis:DescribeStream",
          "s3-object-lambda:GetObject",
          "secretsmanager:GetSecretValue"

        ],
        "Resource" : [
          "arn:aws:transcribe:${var.region}:${data.aws_caller_identity.current.account_id}:transcription-job/*",
          "${aws_kinesis_stream.CTR_kinesis_stream.arn}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}/*",
          #"arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:EDH-*",
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:SMTP-*",
          "${aws_lambda_function.kvs_recording_processor_lambda.arn}",
          "${aws_lambda_function.post_call_survey_utility_lambda.arn}",
          #"${aws_lambda_function.voicemail_notification_lambda.arn}",
          "arn:aws:kinesisvideo:${var.region}:${data.aws_caller_identity.current.account_id}:stream/*",
          "arn:aws:s3-object-lambda:${var.region}:${data.aws_caller_identity.current.account_id}:accesspoint/*",
          "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.connect_core_api.id}/*"
        ]
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "comprehend:DetectSentiment"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })


  tags = merge(local.common_tags, {
    name = "ctr_processor_lambda-policy-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_iam_role_policy_attachment" "ctr_processor_policy_attach" {
  role       = aws_iam_role.ctr_processor_lambda_role.name
  policy_arn = aws_iam_policy.ctr_processor_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "ctr_processor_policy_logging" {
  role       = aws_iam_role.ctr_processor_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "ctr_processor_lambda_VPCAccessExecutionRole" {
  role       = aws_iam_role.ctr_processor_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

### post-call-survey-utility


# post-call-survey-processor
resource "aws_iam_role" "post_call_survey_utility_lambda_role" {
  name = "post_call_survey_utility_lambda-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "post_call_survey_utility_lambda-role-${var.client}-${var.region}-${var.environment}"
  })

}

#post call survey processor
resource "aws_iam_policy" "post_call_survey_utility_lambda_policy" {
  name        = "post_call_survey_utility_lambda-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for post call survey processor lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PostCallSurveyProcessor",
        "Effect" : "Allow",
        "Action" : [
          "transcribe:GetTranscriptionJobs",
          "kinesis:GetShardIterator",
          "kinesis:Get*",
          "kinesisvideo:Describe*",
          "kinesisvideo:Get*",
          "kinesisvideo:List*",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "lambda:InvokeFunction",
          "lambda:InvokeAsync",
          "transcribe:StartTranscriptionJob",
          "kinesis:DescribeStream",
          "s3-object-lambda:GetObject",
        ]
        "Resource" : [
          "arn:aws:transcribe:${var.region}:${data.aws_caller_identity.current.account_id}:transcription-job/*",
          "${aws_kinesis_stream.CTR_kinesis_stream.arn}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}",
          "arn:aws:s3:::${aws_s3_bucket.voice_mail.id}/*",
          #"${aws_lambda_function.voicemail_notification_lambda.arn}",
          "arn:aws:kinesisvideo:${var.region}:${data.aws_caller_identity.current.account_id}:stream/*",
          "arn:aws:s3-object-lambda:${var.region}:${data.aws_caller_identity.current.account_id}:accesspoint/*"

        ]
      },
      {
        "Action" : [
          "comprehend:DetectSentiment"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })

  tags = merge(local.common_tags, {
    name = "post_call_survey_utility_lambda-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "attach_post_call_survey_utility_policy" {
  role       = aws_iam_role.post_call_survey_utility_lambda_role.name
  policy_arn = aws_iam_policy.post_call_survey_utility_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "post_call_survey_utility_policy_logging" {
  role       = aws_iam_role.post_call_survey_utility_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "post_call_survey_utility_lambda_VPCAccess" {
  role       = aws_iam_role.post_call_survey_utility_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#Insurance Identification Trigger


resource "aws_iam_role" "insurance_identification_trigger_lambda_role" {
  name = "insurance-id-trigger-lambda-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "InsuranceIdentificationTrigger"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "insurance-identification-trigger-lambda_role-${var.client}-${var.region}-${var.environment}"
  })

}


resource "aws_iam_policy" "insurance_identification_trigger_lambda_policy" {
  name        = "insurance_identification_trigger_lambda-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for insurance identification trigger lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "insuranceIdentification",
        "Effect" : "Allow",
        "Action" : [
          "apigateway:GET",
          "apigateway:POST",
          "execute-api:Invoke",
          "execute-api:ManageConnections",
        ]
        "Resource" : [
          "arn:aws:apigateway:${var.region}::/restapis/*/*",
          "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:*/*"

        ]
      }

    ]
  })

  tags = merge(local.common_tags, {
    name = "insurance_identification_trigger_lambda-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "attach_insurance_identification_trigger_policy" {
  role       = aws_iam_role.insurance_identification_trigger_lambda_role.name
  policy_arn = aws_iam_policy.insurance_identification_trigger_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "insurance_identification_trigger_policy_logging" {
  role       = aws_iam_role.insurance_identification_trigger_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "insurance_identification_trigger_lambda_VPCAccess" {
  role       = aws_iam_role.insurance_identification_trigger_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


#insurance service 

resource "aws_iam_role" "insurance_services_lambda_role" {
  name = "insurance-service-lambda-role-${var.client}-${var.region}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "InsuranceIdentificationTrigger"
      }
    ]
  })
  tags = merge(local.common_tags, {
    name = "insurance-service-lambda_role-${var.client}-${var.region}-${var.environment}"
  })

}


resource "aws_iam_policy" "insurance_service_lambda_policy" {
  name        = "insurance_service_lambda-policy-${var.client}-${var.region}-${var.environment}"
  path        = "/"
  description = "IAM policy for insurance service lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "InsuranceService",
        "Effect" : "Allow",
        "Action" : [
          "apigateway:GET",
          "apigateway:POST",
          "execute-api:Invoke",
          "execute-api:ManageConnections",
        ]
        "Resource" : [
          "arn:aws:apigateway:${var.region}::/restapis/*/*",
          "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:*/*"

        ]
      }

    ]
  })

  tags = merge(local.common_tags, {
    name = "insurance_service_lambda-policy-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_iam_role_policy_attachment" "attach_insurance_service_policy" {
  role       = aws_iam_role.insurance_services_lambda_role.name
  policy_arn = aws_iam_policy.insurance_service_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "insurance_service_policy_logging" {
  role       = aws_iam_role.insurance_services_lambda_role.name
  policy_arn = aws_iam_policy.common_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "insurance_service_lambda_VPCAccess" {
  role       = aws_iam_role.insurance_services_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
```
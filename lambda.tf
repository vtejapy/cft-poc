```
locals {
  #functions           = ["post_call_pull_lambda", "post_call_util_lambda", "queue_exp_lambda", "holiday_emergency_lambda"]
  dynamodb_table_name = "queue-experience-db-${var.client}-${var.region}-${var.environment}"
  rds_secret_name = regex(
    "^rds!db-[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}",
    split(":", aws_db_instance.postgres_rds.master_user_secret[0].secret_arn)[6]
  )
}

##############################

data "archive_file" "common_lambda_archive" {
  type        = "zip"
  source_file = "src/sample_python.py"
  output_path = "src/lambda_function.zip"
}

###Layers

#genpact-itr-agent-desktop

resource "aws_lambda_layer_version" "ctr_processor_genpact_itr_agent_desktop_layer" {
  filename                 = "src/layers/genpact-itr-agent-desktop.zip"
  layer_name               = "genpact-itr-agent-desktop"
  description              = "genpact-itr-agent-desktop layer for voice mail lambda notification"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]
}

resource "aws_lambda_layer_version" "post_ctr_postgresnew_layer" {
  filename                 = "src/layers/genpact-postgresnew.zip"
  layer_name               = "genpact-postgresnew"
  description              = "genpact-postgresnew layer for voice mail lambda notification"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]
}

resource "aws_lambda_layer_version" "pysmtp_layer" {
  filename                 = "src/layers/genpact-pysmtp.zip"
  layer_name               = "genpact-pysmtp"
  description              = "genpact-pysmtp layer for connect notification lambda"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]
}

resource "aws_lambda_layer_version" "pyrequests_layer" {
  filename                 = "src/layers/genpact-pyrequests.zip"
  layer_name               = "genpact-pyrequests"
  description              = "genpact-pyrequests layer for holiday emergency message, nocallback period lambda and  post call pull lambda"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]

}

# resource "aws_lambda_layer_version" "ctr_processor_kvstos3wavefile_layer" {
#   filename                 = "src/layers/genpact-kvstos3wavefile.zip"
#   layer_name               = "genpact-kvstos3wavefile"
#   description              = "genpact-kvstos3wavefile layer for voice mail lambda"
#   compatible_architectures = ["x86_64"]
#   compatible_runtimes      = ["python3.10"]

# }

resource "aws_lambda_layer_version" "ctr_processor_axiosrequest_layer" {
  filename                 = "src/layers/genpact-axiosrequest.zip"
  layer_name               = "genpact-axiosrequest"
  description              = "genpact-axiosrequest layer for voice mail lambda"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]

}


resource "aws_lambda_layer_version" "node_mailer_layer" {
  filename                 = "src/layers/genpact-nodemailer.zip"
  layer_name               = "genpact-nodemailer"
  description              = "genpact-nodemailer layer for voice mail lambda notification"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = [var.lambda_nodejs_runtime]

}

resource "aws_lambda_layer_version" "aws_crypto_layer" {
  filename                 = "src/layers/genpact-awscrypto.zip"
  layer_name               = "genpact-awscrypto"
  description              = "genpact-awscrypto layer for voice mail lambda notification"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = [var.lambda_nodejs_runtime]

}
resource "aws_lambda_layer_version" "kvs2ACwav_layer" {
  filename                 = "src/layers/genpact-kvs2ACwav.zip"
  layer_name               = "genpact-kvs2ACwav"
  description              = "genpact-kvs2ACwav layer for voice mail lambda notification"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = [var.lambda_nodejs_20_runtime]

}

resource "aws_lambda_layer_version" "jwt_layer" {
  filename                 = "src/layers/genpact-jwt.zip"
  layer_name               = "genpact-jwt"
  description              = "genpact-jwt layer"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]

}
resource "aws_lambda_layer_version" "psycopg2_new_layer" {
  filename                 = "src/layers/genpact-psycopg2-new.zip"
  layer_name               = "genpact-psycopg2_new"
  description              = "genpact-psycopg2_new"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.10"]

}

################################################
##             Security Group                 ##
################################################

# resource "aws_security_group" "lambda_sg" {
#   name        = "ccm_lambda_security_group"
#   description = "Allow TLS inbound traffic from Lambda security group"
#   vpc_id      = aws_vpc.genpact_poc_vpc.id

#   tags = merge(local.common_tags, {
#     Name = "ccm_lambda_security_group"
#   })
# }

# commom lambda security group
resource "aws_security_group" "common_lambda_sg" {
  name        = "command-lambda-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow TLS inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "command-lambda-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "common_lambda_sg_ingress" {
  security_group_id = aws_security_group.common_lambda_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "common-lambda-sg-ingress-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_vpc_security_group_egress_rule" "common_lambda_sg_egress" {
  security_group_id = aws_security_group.common_lambda_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "To Allow lambda to call Genworth Stage SSO"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "common-lambda-sg-egress-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_vpc_security_group_egress_rule" "db_access_common_lambda_sg_egress" {
  security_group_id = aws_security_group.common_lambda_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "To Allow lambda to call Genworth Stage SSO"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "db_access_common-lambda-sg-egress-${var.client}-${var.region}-${var.environment}"
  })
}

#lambda security group 

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_rds_security_group"
  description = "Allow TLS inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "lambda-sg-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_vpc_security_group_ingress_rule" "lambda_sg_ingress" {
  security_group_id = aws_security_group.lambda_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "lambda-sg-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

# resource "aws_vpc_security_group_egress_rule" "lambda_sg_egress" {
#   security_group_id = aws_security_group.lambda_sg.id
#   cidr_ipv4         = var.vpc_cidr
#   description       = "To Allow lambda to call AWS service APIs"
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "lambda-sg-egress-${var.client}-${var.region}-${var.environment}"
#   })
# }


resource "aws_vpc_security_group_egress_rule" "https_lambda_sg_egress" {
  security_group_id = aws_security_group.lambda_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "To Allow lambda to call https port"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "https-lambda-sg-egress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "lambda_rds_egress" {
  security_group_id            = aws_security_group.lambda_sg.id
  referenced_security_group_id = aws_security_group.rds_sg.id
  description                  = "To Allow RDS to call AWS service APIs"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  tags = merge(local.common_tags, {
    Name = "lambda-rds-egress-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_security_group" "connect_lambda" {
  name        = "connect_lambda_security_group"
  description = "Allow TLS inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "connect-lambda-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "connect_sg_egress" {
  security_group_id = aws_security_group.connect_lambda.id
  cidr_ipv4         = var.vpc_cidr
  description       = "To Allow lambda to call AWS service APIs"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "ccm-connect-lambda-egress"
  })
}

#############

#comman center 

#  command center

resource "aws_security_group" "command_center_sg" {
  name        = "command-center-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "command-center-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "command-center_sg_ingress" {
  security_group_id = aws_security_group.command_center_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "command-center-lambda-ingress"
  })
}

# resource "aws_vpc_security_group_egress_rule" "command_center_sg_egress" {
#   security_group_id            = aws_security_group.command_center_sg.id
#   cidr_ipv4                    = var.vpc_cidr
#   description                  = "Allow egress from labmda security group to lambda security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "command-center-lambda-egress"
#   })
# }


resource "aws_lambda_function" "command_center_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "command-center-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.command_center_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.lambda_memory_size
  layers           = [aws_lambda_layer_version.ctr_processor_genpact_itr_agent_desktop_layer.arn]
  timeout          = var.lambda_timeout
  runtime          = var.lambda_runtime
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.command_center_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      BUCKET_ENDPOINT_URL = replace("https://bucket.${aws_vpc_endpoint.s3_endpoint.dns_entry[0].dns_name}", "*.", "")
      DATABASE_ENDPOINT   = split(":", aws_db_instance.postgres_rds.endpoint)[0]
      DATABASE_NAME       = var.db_name
      DATABASE_PORT       = var.database_port
      INSTANCE_ID         = aws_connect_instance.genpact_poc.id
      REGION_NAME         = var.region
      S3_BUCKET           = aws_s3_bucket.voice_mail.id
      S3_PREFIX           = "/"
      SCHEME_NAME         = var.schema_name
      SECRET_MANAGER_NAME = local.rds_secret_name #split(":", aws_db_instance.postgres_rds.master_user_secret[0].secret_arn)[6]
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  tags = merge(local.common_tags, {
    Name = "command-center-lambda-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.command_center_sg]
}


# ##core api

resource "aws_security_group" "contact_center_core_api_sg" {
  name        = "contact-center-core-api-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "contact-center-core-api-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "contact_center_core_api_sg_ingress" {
  security_group_id = aws_security_group.contact_center_core_api_sg.id
  #referenced_security_group_id = aws_security_group.lambda_sg.id
  cidr_ipv4   = var.vpc_cidr
  description = "Allow ingress from labmda security group"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact-center-core-api-lambda-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "contact_center_core_api_sg_egress" {
  security_group_id = aws_security_group.contact_center_core_api_sg.id
  #referenced_security_group_id = aws_security_group.lambda_sg.id
  cidr_ipv4   = var.vpc_cidr
  description = "Allow egress from labmda security group"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact-center-core-api-lambda-egress"
  })
}

resource "aws_lambda_function" "contact_center_core_api_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "contact-center-core-api-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.contact_center_core_api_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.ctr_processor_lambda_memory_size
  layers = [
    aws_lambda_layer_version.ctr_processor_genpact_itr_agent_desktop_layer.arn,
    aws_lambda_layer_version.jwt_layer.arn,
    aws_lambda_layer_version.psycopg2_new_layer.arn
  ]
  timeout = var.lambda_timeout
  runtime = var.lambda_runtime
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.contact_center_core_api_sg.id, aws_security_group.connect_lambda.id, aws_security_group.rds_sg.id, aws_security_group.lambda_sg.id]
  }
  environment {
    variables = {
      BUCKET_ENDPOINT_URL = replace("https://bucket.${aws_vpc_endpoint.s3_endpoint.dns_entry[0].dns_name}", "*.", "")
      DATABASE_ENDPOINT   = split(":", aws_db_instance.postgres_rds.endpoint)[0]
      DATABASE_NAME       = var.db_name
      DATABASE_PORT       = var.database_port
      INSTANCE_ID         = aws_connect_instance.genpact_poc.id
      REGION_NAME         = var.region
      S3_BUCKET           = aws_s3_bucket.voice_mail.id
      S3_PREFIX           = "/"
      SCHEME_NAME         = var.schema_name
      SECRET_MANAGER_NAME = local.rds_secret_name #split(":", aws_db_instance.postgres_rds.master_user_secret[0].secret_arn)[6]
    }
  }

  tags = merge(local.common_tags, {
    Name = "contact-center-core-api-lambda-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.contact_center_core_api_sg]

  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}

resource "aws_lambda_permission" "contact_center_core_api_trigger" {
  statement_id  = "contactCenterApiTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_center_core_api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.connect_core_api.execution_arn}/*/*/*"

}

resource "aws_lambda_permission" "command_center_api_trigger" {
  statement_id  = "commandCenterApiTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.command_center_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.command_center.execution_arn}/*/*/*"

}

##### kvs-processor

resource "aws_lambda_function" "kvs_recording_processor_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "kvs-processor-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.kvs_recording_processor_lambda_role.arn
  handler          = var.kvs_recording_processor_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.kvs_recording_processor_memory_size
  runtime          = var.lambda_nodejs_20_runtime
  timeout          = var.kvs_recording_processor_timeout
  layers           = [aws_lambda_layer_version.kvs2ACwav_layer.arn, aws_lambda_layer_version.aws_crypto_layer.arn, aws_lambda_layer_version.node_mailer_layer.arn, aws_lambda_layer_version.ctr_processor_axiosrequest_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  tags = merge(local.common_tags, {
    Name = "kvs-processor-lambda-${var.client}-${var.region}-${var.environment}"
  })

  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}

#### ContactLens-Evaluation-loader

resource "aws_security_group" "contactLens_evaluation_loader_sg" {
  name        = "contactLens-evaluation-loader-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "contactLens-evaluation-loader-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "contactLens_evaluation_loader_sg_ingress" {
  security_group_id = aws_security_group.contactLens_evaluation_loader_sg.id
  #referenced_security_group_id = aws_security_group.lambda_sg.id
  cidr_ipv4   = var.vpc_cidr
  description = "Allow ingress from labmda security group to rds security group"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  tags = merge(local.common_tags, {
    Name = "contactLens-evaluation-loader-lambda-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "contactLens_evaluation_loader_sg_egress" {
  security_group_id            = aws_security_group.contactLens_evaluation_loader_sg.id
  referenced_security_group_id = aws_security_group.lambda_sg.id
  description                  = "Allow egress from labmda security group to lambda security group"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  tags = merge(local.common_tags, {
    Name = "contactLens-evaluation-loader-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_vpc_security_group_egress_rule" "contactLens_evaluation_loader_rds_sg_egress" {
  security_group_id            = aws_security_group.contactLens_evaluation_loader_sg.id
  referenced_security_group_id = aws_security_group.connect_lambda.id
  description                  = "Allow egress from labmda security group to lambda security group"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  tags = merge(local.common_tags, {
    Name = "contactLens-evaluation-loader-rds-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}


resource "aws_lambda_function" "contactLens_evaluation_loader_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "contactLens-evaluation-loader-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.contactLens_evaluation_loader_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.lambda_memory_size
  layers = [
    aws_lambda_layer_version.post_ctr_postgresnew_layer.arn,
    "arn:aws:lambda:${var.region}:${var.pandas_layer_account}:layer:AWSSDKPandas-Python310:19"
  ]
  timeout = var.contactLens_timeout
  runtime = var.lambda_runtime
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.contactLens_evaluation_loader_sg.id, aws_security_group.connect_lambda.id, aws_security_group.lambda_sg.id, aws_security_group.rds_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      obucket_endpoint_url = replace("https://bucket.${aws_vpc_endpoint.s3_endpoint.dns_entry[0].dns_name}", "*.", "")
      #bucket_name          = s3_bucket_id.exported_reports.id
      contact_lens_path    = var.contact_lens_path
      headers1             = var.headers1
      headers2             = var.headers2
      host                 = aws_db_instance.postgres_rds.endpoint
      port                 = aws_db_instance.postgres_rds.port
      postcall_survey_path = var.postcall_survey_path
      query1               = var.query1
      query2               = var.query2
      region_name          = var.region
      secret_name          = local.rds_secret_name #split(":", aws_db_instance.postgres_rds.master_user_secret[0].secret_arn)[6]
      #ctr_bucket_name      = s3_bucket_id.exported_reports.id
      ctr_prefix = var.ctr_prefix
      #ctr_processed_bucket = s3_bucket_id.exported_reports.id
      ctr_processed_prefix = var.ctr_processed_prefix
      #edh_ctr_api_url      = var.edh_putctr_api
      edh_secret_name = var.edh_secret_name
      #get_token_url   = var.get_token_url
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  tags = merge(local.common_tags, {
    Name = "contactLens-evaluation-loader-lambda-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.contactLens_evaluation_loader_sg]
}

# outbound-contact-precheck-utility

resource "aws_lambda_function" "outbound_contact_precheck_utility_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "outbound-contact-prechk-util-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.outbound_contact_precheck_utility_lambda_role.arn
  handler          = var.outbound_contact_precheck_utility_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.lambda_memory_size
  runtime          = var.outbound_contact_precheck_utility_runtime
  timeout          = var.outbound_contact_precheck_utility_timeout
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      INSTANCE_ID = aws_connect_instance.genpact_poc.id
      #notification_lambda_arn = aws_lambda_function.amazon_connect_notification_lambda.arn
      #child_lambda            = aws_lambda_function.amazon_connect_notification_lambda.function_name

    }
  }

  tags = merge(local.common_tags, {
    Name = "outbound-contact-prechk-util-lambda-${var.client}-${var.region}-${var.environment}"
  })

  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}



# cloudwatch-alarm-processor

resource "aws_lambda_permission" "cloudwatch_alarm_processor_permission" {
  statement_id  = "AlarmAction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_alarm_processor_lambda.function_name
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
}

resource "aws_lambda_function" "cloudwatch_alarm_processor_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "cloudwatch-alarm-processor-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.cloudwatch_alarm_processor_lambda_role.arn
  handler          = var.cloudwatch_alarm_processor_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.cloudwatch_alarm_processor_memory_size
  runtime          = var.cloudwatch_alarm_processor_runtime
  timeout          = var.cloudwatch_alarm_processor_timeout
  layers           = [aws_lambda_layer_version.node_mailer_layer.arn, aws_lambda_layer_version.aws_crypto_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id, aws_security_group.ctr_processor_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      SMTP_From_Address = var.smtp_from_address
      SMTP_host         = var.smtp_host
      SMTP_port         = var.smtp_port
      SMTP_secret_name  = var.secret_name_smtp
      SMTP_username     = var.smtp_username
      region_name       = var.region
      #mailTo            = var.alarms_mailto
      cw_alarm_api = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/cloudwatch-alarm/get-notification-details/"
    }
  }
  tags = merge(local.common_tags, {
    Name = "cloudwatch-alarm-processor-lambda-${var.client}-${var.region}-${var.environment}"
  })

  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}

## queue-experience-utilit-utility


resource "aws_security_group" "queue_experience_utility_sg" {
  name        = "queue-experience-utility-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "queue-experience-utility-lambda-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "queue_experience_utility_sg_ingress" {
  security_group_id = aws_security_group.queue_experience_utility_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to queue experience"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "queue-experience-utility-lambda-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "queue_experience_utility_sg_egress" {
  security_group_id = aws_security_group.queue_experience_utility_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "queue-experience-utility-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_lambda_function" "queue_experience_utility_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "queue-experience-utilit-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.queue_experience_utility_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.lambda_memory_size
  timeout          = var.queue_experience_utility_lambda_timeout
  runtime          = var.lambda_runtime
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.queue_experience_utility_sg.id, aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  environment {
    variables = {
      DYNAMODB_ENDPOINT_URL = replace("https://${aws_vpc_endpoint.dynamodb_endpoint.dns_entry[0].dns_name}", "*.", ""),
      QueuePositionTable    = local.dynamodb_table_name
      contactflowid         = var.contactflowid
      instanceid            = aws_connect_instance.genpact_poc.id
    }
  }
  tags = merge(local.common_tags, {
    Name = "queue-experience-utility-lambda-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.queue_experience_utility_sg]
}

### contact-prechecks-utility

resource "aws_security_group" "contact_prechecks_utility_sg" {
  name        = "contact-prechecks-utility-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "contact-prechecks-utility-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "contact_prechecks_utility_sg_ingress" {
  security_group_id = aws_security_group.contact_prechecks_utility_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact-prechecks-utility-lambda-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "contact_prechecks_utility_sg_egress" {
  security_group_id = aws_security_group.contact_prechecks_utility_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact-prechecks-utility-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}



resource "aws_lambda_function" "contact_prechecks_utility_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "contact-prechecks-utility-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.contact_prechecks_utility_lambda_role.arn
  handler          = var.contact_prechecks_utility_lambda_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.lambda_memory_size
  timeout          = var.contact_prechecks_utility_lambda_timeout
  runtime          = var.contact_prechecks_utility_lambda_runtime
  layers           = [aws_lambda_layer_version.pyrequests_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.contact_prechecks_utility_sg.id, aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      fraud_number_api = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/fraudnumber/get_number_by_id/"
      get_message_api  = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/prompts-message/get-message"
      region_name      = var.region
      ivr_config_api   = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/ivr-config/get-ivr-config"
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  tags = merge(local.common_tags, {
    Name = "contact-prechecks-utility-lambda-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.contact_prechecks_utility_sg]
}

# ## ctr-processor

resource "aws_security_group" "ctr_processor_sg" {
  name        = "ctr-processor-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "ctr-processor-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ctr_processor_sg_ingress" {
  security_group_id = aws_security_group.ctr_processor_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "ctr-processor-lambda-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "ctr_processor_sg_egress" {
  security_group_id = aws_security_group.ctr_processor_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "ctr-processor-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "ctr_processor_smtp_sg_egress" {
  for_each          = toset(var.smtp_cidrs)
  security_group_id = aws_security_group.ctr_processor_sg.id
  cidr_ipv4         = each.value
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 25
  to_port           = 25
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "ctr-processor-smtp-egress-${var.client}-${var.region}-${var.environment}"
  })
}
resource "aws_vpc_security_group_egress_rule" "ctr_processor_email_sg_egress" {
  for_each          = toset(var.smtp_cidrs)
  security_group_id = aws_security_group.ctr_processor_sg.id
  cidr_ipv4         = each.value
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 587
  to_port           = 587
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "ctr-processor-email-egress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "ctr_processor_route_sg_egress" {

  security_group_id = aws_security_group.ctr_processor_sg.id
  cidr_ipv4         = "10.0.0.0/8"
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "ctr-processor-route-egress-${var.client}-${var.region}-${var.environment}"
  })
}



resource "aws_lambda_function" "ctr_processor_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "ctr-processor-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.ctr_processor_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.ctr_processor_lambda_memory_size
  timeout          = var.ctr_processor_lambda_timeout
  runtime          = var.lambda_nodejs_runtime
  layers           = [aws_lambda_layer_version.kvs2ACwav_layer.arn, aws_lambda_layer_version.aws_crypto_layer.arn, aws_lambda_layer_version.node_mailer_layer.arn, aws_lambda_layer_version.ctr_processor_axiosrequest_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      aws_region                = var.region
      BUCKET_ENDPOINT_URL       = ""
      SMTP_From_Address         = ""
      SMTP_Mail_Template_CC_URL = ""
      SMTP_host                 = ""
      SMTP_port                 = ""
      SMTP_secret_name          = ""
      SMTP_username             = ""
      aws_region                = ""
      child_lambda_name         = ""
      Not_required              = ""
      ctr_bucket_name           = ""
      ctr_prefix                = ""
      mail_id_api               = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/voicemail/get-voicemail-delivery-setups-by-aws-id"
      putctr_api                = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/ctr/putctr"
      #child_lambda_name         = aws_lambda_function.voicemail_notification_lambda.function_name
      s3_ivrRecording_bucket   = "${aws_s3_bucket.voice_mail.id}/IvrRecordings"
      s3_postcallsurvey_bucket = "${aws_s3_bucket.voice_mail.id}/PostcallSurveyRecordings"
      s3_voicemail_bucket      = "${aws_s3_bucket.voice_mail.id}/Voicemail"
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  tags = merge(local.common_tags, {
    Name = "ctr-processor-lambda-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.ctr_processor_sg]
}

resource "aws_lambda_event_source_mapping" "voicemail_lambda_event_source" {
  batch_size                     = var.voicemail_batch_size
  maximum_retry_attempts         = var.voicemail_maximum_retry_attempts
  parallelization_factor         = var.voicemail_parallelization_factor
  bisect_batch_on_function_error = var.bisect_batch_on_function_error
  event_source_arn               = aws_kinesis_stream.CTR_kinesis_stream.arn
  function_name                  = aws_lambda_function.ctr_processor_lambda.arn
  starting_position              = "LATEST"

  depends_on = [
    aws_iam_role_policy_attachment.ctr_processor_policy_attach
  ]
}


## post-call-survey-utility

resource "aws_lambda_function" "post_call_survey_utility_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "post-call-survey-utility-lambda-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.post_call_survey_utility_lambda_role.arn
  handler          = var.post_call_survey_utility_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.post_call_survey_utility_memory_size
  runtime          = var.post_call_survey_utility_runtime
  timeout          = var.post_call_survey_utility_timeout
  layers           = [aws_lambda_layer_version.pyrequests_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  tags = merge(local.common_tags, {
    Name = "post-call-survey-utility-lambda-${var.client}-${var.region}-${var.environment}"
  })
  environment {
    variables = {
      base_url    = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/postcallsurvey/get-survey-details/"
      region_name = var.region
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}

### insurance_identification_trigger

resource "aws_security_group" "insurance_identification_trigger_sg" {
  name        = "insurance-identification-triggers-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "insurance-identification-triggers-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "insurance_identification_trigger_sg_ingress" {
  security_group_id = aws_security_group.insurance_identification_trigger_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "insurance-identification-trigger-lambda-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "insurance_identification_trigger_sg_egress" {
  security_group_id = aws_security_group.insurance_identification_trigger_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "insurance-identification-trigger-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_lambda_function" "insurance_identification_trigger_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "insurance-identification-and-triggers-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.insurance_identification_trigger_lambda_role.arn
  handler          = var.insurance_identification_trigger_lambda_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.insurance_identification_trigger_memory_size
  timeout          = var.insurance_identification_trigger_lambda_timeout
  runtime          = var.insurance_identification_trigger_lambda_runtime
  layers           = [aws_lambda_layer_version.pyrequests_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.insurance_identification_trigger_sg.id, aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      auth_url                    = ""
      bot_secret_url              = ""
      cl_queue                    = ""
      cs_queue                    = ""
      event_url                   = ""
      ext_url                     = ""
      identify_producer_phone_url = ""
      identify_producer_url       = ""
      reconnect_url               = ""
      get_premium_details_url     = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/insurance-core/getPremiumDetails?policy_number={policy_number}"
      identify_phone_url          = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/insurance-core/identifyByPhoneNumber?phone_number={phone_number}&role={role}"
      region_name                 = var.region
      identify_policy_claim_url   = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/insurance-core/getPolicyDetails?policy_or_claim_number={policy_or_claim_number}&role={role}"
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  tags = merge(local.common_tags, {
    Name = "insurance-identification-and-triggers-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.insurance_identification_trigger_sg]
}

### insurance_services

resource "aws_security_group" "insurance_services_sg" {
  name        = "insurance-services-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from Lambda security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "insurance-services-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "insurance_services_sg_ingress" {
  security_group_id = aws_security_group.insurance_services_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from labmda security group to rds security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "insurance-identification-trigger-lambda-ingress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_egress_rule" "insurance_services_sg_egress" {
  security_group_id = aws_security_group.insurance_services_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from labmda security group to lambda security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "insurance-identification-trigger-lambda-egress-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_lambda_function" "insurance_services_lambda" {
  filename         = data.archive_file.common_lambda_archive.output_path
  function_name    = "insurance-services-${var.client}-${var.region}-${var.environment}"
  role             = aws_iam_role.insurance_services_lambda_role.arn
  handler          = var.insurance_services_lambda_handler
  source_code_hash = data.archive_file.common_lambda_archive.output_base64sha256
  memory_size      = var.insurance_services_memory_size
  timeout          = var.insurance_services_lambda_timeout
  runtime          = var.insurance_services_lambda_runtime
  layers           = [aws_lambda_layer_version.pyrequests_layer.arn]
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.insurance_services_sg.id, aws_security_group.lambda_sg.id, aws_security_group.common_lambda_sg.id]
  }
  environment {
    variables = {
      fraud_number_api = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/fraudnumber/get_number_by_id/"
      get_message_api  = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/prompts-message/get-message"
      region_name      = var.region
      ivr_config_api   = "${aws_api_gateway_stage.conect_core_private_api_stage.invoke_url}/api/ivr-config/get-ivr-config"
    }
  }
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
  tags = merge(local.common_tags, {
    Name = "insurance-services-${var.client}-${var.region}-${var.environment}"
  })
  depends_on = [aws_security_group.insurance_services_sg]
}
```
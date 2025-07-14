#varible

```
variable "environment" {
  description = "Environment dev or stg or prod"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "aws region for deployment"
  type        = string
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.113.0.0/16"
}

variable "client" {
  description = "client name"
  type        = string
  default     = "gen-client5"
}
variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "genpact-ccm"
}
variable "private_cidr_offset" {
  description = "The starting offset for private subnet CIDR blocks"
  type        = number
  default     = 10
}
variable "public_cidr_offset" {
  type    = number
  default = 20
}
variable "sg_name" {
  description = "Security group name"
  type        = string
  default     = "rds-postgres-sg"
}

variable "sg_description" {
  description = "Security group description"
  type        = string
  default     = "Allow PostgreSQL access"
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks for PostgreSQL access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_subnet_group_name" {
  description = "Name for the DB subnet group"
  type        = string
  default     = "rds-db-subnet-group"
}
variable "appService" {
  type    = string
  default = "client"
}
variable "multi_az" {
  description = "AWS account ID"
  type        = bool
  default     = true
}
variable "cost_center" {
  description = "cost center for billing tags"
  type        = string
  default     = "1003"
}

variable "rds_engine_version" {
  description = "The version of the RDS engine"
  type        = string
  default     = "16.3"
}

variable "rds_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_allocated_storage" {
  description = "The allocated storage for the RDS instance (in GB)"
  type        = number
  default     = 100
}

variable "rds_storage_type" {
  description = "rds storage type"
  type        = string
  default     = "gp3"
}

variable "rds_backup_retention_period" {
  description = "backup period"
  type        = number
  default     = 7
}

variable "rds_parameter_group_name" {
  description = "The name of the RDS parameter group"
  type        = string
  default     = "rds-parameter-group"
}

variable "rds_option_group_name" {
  description = "The name of the RDS option group"
  type        = string
  default     = "rds-option-parameter-group"
}

variable "db_name" {
  description = "The name of the RDS option group"
  type        = string
  default     = "postgres"
}

variable "rds_username" {
  type    = string
  default = "genpactadmin"
}


variable "secrets" {
  default = {}
  type    = map(string)
}

variable "kms_deletion_window" {
  type    = number
  default = 10
}

variable "infoClass" {
  type    = string
  default = "confidential"
}

variable "deployedBy" {
  type    = string
  default = "terraform"
}

# variable "created_date" {
#   type = string
#   default = formatdate("YYYY-MM-DDT00:00:00", timestamp())
# }

variable "company_name" {
  type    = string
  default = "genpact"
}

variable "rds_maintenance_window" {
  type    = string
  default = "Sun:00:00-Sun:04:00"
}


####lambda

variable "https_outbound_cidr" {
  description = "https subnet cidr for lambda"
  type        = string
  default     = ""
}

variable "lambda_memory_size" {
  description = "The allocated memory size for lambda (in MB)"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 30
}

variable "lambda_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "database_port" {
  description = "postgres db default port number"
  type        = number
  default     = 5432
}

variable "schema_name" {
  description = "schema name"
  type        = string
  default     = "agent_desktop_assist"
}

variable "kvs_recording_processor_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "index.handler"
}
variable "kvs_recording_processor_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "nodejs18.x"
}

variable "kvs_recording_processor_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 180
}
variable "kvs_recording_processor_memory_size" {
  description = "memory size for lambda (in mbs)"
  type        = number
  default     = 512
}
variable "pandas_layer_account" {
  description = "aws managed pandsas layer account number"
  type        = string
  default     = "336392948345"
}
variable "contactLens_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 900
}

variable "contact_lens_path" {
  description = "contact lens path"
  type        = string
  default     = "Reports/EDH/Daily/ContactLens"
}

variable "headers1" {
  description = "A list of headers1"
  type        = string
  default     = "Contact ID,Contact Date,Agent ID,Agent Name,Survey ID, Question1 ID, Answer1, Question2 ID,Answer2,Question3 ID,Answer3,Question4 ID,Answer4,Question5 ID,Answer5,Question6 ID,Answer6,Customer Sentiment score"
}

variable "headers2" {
  description = "A list of headers2"
  type        = string
  default     = "Contact ID,Contact Date,Agent Name,Call Category,Sentiment Score"
}
variable "query1" {
  type    = string
  default = "SELECT t1.contact_id, t1.created_at, t3.ai_agentid, t3.ai_agentname, t1.survey_id, t1.question_id, t1.results, t1.comprehend FROM agent_desktop_assist.postcallsurveyresults t1 INNER JOIN agent_desktop_assist.postcallsurveyquestions t2 ON t1.question_id = t2.question_id INNER JOIN agent_desktop_assist.agentinteraction t3 ON t1.contact_id = t3.ai_contactid WHERE DATE(t1.created_at) = CURRENT_DATE order by created_at;"
}
variable "query2" {
  type    = string
  default = "SELECT clr_contact_id, clr_created_date,ai_agentname AS interaction_agent_name, clr_call_category, clr_sentiment FROM agent_desktop_assist.contactlensedhreport AS clr INNER JOIN agent_desktop_assist.agentinteraction AS ai ON clr.clr_contact_id = ai.ai_contactid where date(clr.clr_created_date)= CURRENT_DATE;"
}
variable "postcall_survey_path" {
  description = "post call survey path"
  type        = string
  default     = "Reports/EDH/Daily/PostCallSurvey"
}

variable "ctr_prefix" {
  description = "CTR  Prefix"
  type        = string
  default     = "CTR/ErrorRecords/"
}

variable "ctr_processed_prefix" {
  description = "CTR Processed Prefix"
  type        = string
  default     = "CTR/Processed/"
}

variable "cloudwatch_alarm_processor_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "index.handler"
}
variable "cloudwatch_alarm_processor_memory_size" {
  description = "memory size for lambda (in mbs)"
  type        = number
  default     = 256
}
variable "cloudwatch_alarm_processor_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "nodejs20.x"
}

variable "cloudwatch_alarm_processor_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 10
}

variable "smtp_from_address" {
  type    = string
  default = "$gnwcc-dev@genworth.com"
}

variable "smtp_host" {
  type    = string
  default = "smtp.genworth.net"
}

variable "smtp_port" {
  description = "smtp port"
  type        = number
  #sensitive   = true
  default = 587
}
variable "secret_name_smtp" {
  type    = string
  default = "SMTP"
}
variable "smtp_username" {
  description = "smtp user name"
  type        = string
  #sensitive   = true
  default = "smtp-user"
}

# variable "secret_name_smtp" {
#   type    = string
#   default = "SMTP"
# }

variable "queue_experience_utility_lambda_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 300
}

variable "contactflowid" {
  description = "connect contact flow id"
  type        = string
  default     = ""
}

variable "holiday_emergency_lambda_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "contact_prechecks_utility_lambda_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}
variable "contact_prechecks_utility_lambda_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "contact_prechecks_utility_lambda_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 15
}
variable "smtp_cidrs" {
  description = "List of CIDR ranges for smtp"
  type        = list(string)
  default     = ["172.16.14.210/32", "172.16.14.211/32", "172.40.212.200/32", "172.40.212.201/32"]
}

variable "lambda_nodejs_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_nodejs_20_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "nodejs20.x"
}

variable "ctr_processor_lambda_memory_size" {
  description = "The allocated memory size for lambda (in MB)"
  type        = number
  default     = 512
}
variable "ctr_processor_lambda_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 600
}

variable "voicemail_batch_size" {
  description = "event source mapping batch size for voice mail lambda"
  type        = number
  default     = 5
}
variable "voicemail_notification_memorysize" {
  description = "memory size for voice mail notificationlambda"
  type        = number
  default     = 256
}

variable "voicemail_maximum_retry_attempts" {
  description = "event stream number of retry after failure"
  type        = number
  default     = 1
}

variable "voicemail_parallelization_factor" {
  description = "event stream parallelization factor"
  type        = number
  default     = 5
}
variable "bisect_batch_on_function_error" {
  description = "returns an error, split the batch in two and retry"
  type        = bool
  default     = true
}
variable "post_call_survey_utility_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}
variable "post_call_survey_utility_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "post_call_survey_utility_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 180
}
variable "post_call_survey_utility_memory_size" {
  description = "memory size for lambda (in mbs)"
  type        = number
  default     = 512
}

variable "rec_trans_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 2555
}

# variable "edh_username" {
#   type      = string
#   sensitive = true
# }

# variable "edh_password" {
#   description = "password for edh to fetch secret keys from secret manager"
#   type        = string
#   sensitive   = true
# }

# variable "smtp_password" {
#   description = "password for smtp to fetch secret keys from secret manager"
#   type        = string
#   sensitive   = true
# }

variable "smtp_hostname" {
  type    = string
  default = "test.genpact.com"
}

variable "rec_trans_it_transition" {
  description = "transition period (in days)"
  type        = number
  default     = 90
}

variable "rec_trans_glacier_transition" {
  description = "transition period (in days)"
  type        = number
  default     = 365
}

variable "abort_incomplete" {
  description = "retention period (in days)"
  type        = number
  default     = 7
}
variable "ccenter_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 360
}

variable "exp_reports_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 180
}
variable "screen_rec_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 60
}

variable "voicemail_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 30
}

variable "lex_bot_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 180
}
variable "bucket_logging_expiration" {
  description = "object retention period (in days)"
  type        = number
  default     = 180
}
variable "edh_putctr_api" {
  type    = string
  default = ""
}
variable "edh_secret_name" {
  type    = string
  default = "EDH"
}
variable "get_token_url" {
  type    = string
  default = ""
}
variable "outbound_contact_precheck_utility_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}
variable "outbound_contact_precheck_utility_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "outbound_contact_precheck_utility_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 300
}
variable "shard_count" {
  description = "shard count for Kinesis"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "retention period (in hours)"
  type        = number
  default     = 24
}
variable "greater_comparison_operator" {
  description = "Operator for comparing statistic to threshold."
  type        = string
  default     = "GreaterThanThreshold"
}
variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = 1
}
variable "calls_perinterval_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = 5
}
variable "longestqueuewait_metrics" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "LongestQueueWaitTime"
}
variable "connect_namespace" {
  description = "The namespace for the alarm's associated metric"
  type        = string
  default     = "AWS/Connect"
}
variable "sum_statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  type        = string
  default     = "Sum"
}
variable "treat_missing_data" {
  description = "this alarm is to handle missing data points."
  type        = string
  default     = "missing"
}
variable "threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 10
}
variable "CallsPerInterval_metric_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "CallsPerInterval"
}
variable "latency_metrics_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "Latency"
}
variable "api_gateway_threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 20000
}
variable "api_gateway_period" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 300
}
variable "period" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 300
}
variable "metric_name_5xx_error" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "5xx" # 5XXError
}
variable "apigateway_namespace" {
  description = "The namespace for the alarm's associated metric"
  type        = string
  default     = "AWS/ApiGateway"
}
variable "packetlossrate_period" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 300
}
variable "packetlossrate_metrice_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "ToInstancePacketLossRate"
}
variable "callbreach_period" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 300
}
variable "callbreaching_metrics_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "CallsBreachingConcurrencyQuota"
}
variable "contact_flow_metrics_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "ContactFlowErrors"
}
variable "queuecapacity_metric_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "QueueCapacityExceededError"
}
variable "apigateway_period" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 300
}
variable "cloudwatchmetrics_alarm_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "index.handler"
}
variable "cloudwatchmetrics_alarm_memory_size" {
  description = "memory size for lambda (in mbs)"
  type        = number
  default     = 256
}
variable "longestqueuewaittime_queue_name" {
  description = "queue name"
  type        = string
  default     = "CS General Inquiry"
}
variable "instance_call_metric_group" {
  description = "metric group name"
  type        = string
  default     = "VoiceCalls"
}

variable "cs_general_contact_flow_name" {
  description = "contact flow name"
  type        = string
  default     = "CS General"
}
variable "dashboard_name" {
  description = "Name of the CloudWatch custom dashboard for Amazon Connect"
  type        = string
  default     = "Amazon-Connect-Metrics"
}
variable "participant" {
  description = "Name of the participant"
  type        = string
  default     = "Agent"
}
variable "typeofConnection" {
  description = "type of Connection"
  type        = string
  default     = "WebRTC"
}
variable "streamType" {
  description = "stream type"
  type        = string
  default     = "Voice"
}
variable "callsbreaching_metricgroup" {
  description = "CallsBreachingConcurrencyQuota metric group"
  type        = string
  default     = "VoiceCalls"
}
variable "contactflow_metricgroup" {
  description = "ContactFlowErrors metric group"
  type        = string
  default     = "ContactFlow"
}
variable "queuecapacity_queue_name" {
  description = "QueueCapacityExceededError queue name"
  type        = string
  default     = "CS General Inquiry"
}
variable "queuecapacity_metricgroup" {
  description = "QueueCapacityExceededError metric group"
  type        = string
  default     = "Queue"
}

variable "CallsPerInterval_threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 5
}
variable "latency_evaluation_periods" {
  description = "latency evaluation period"
  type        = number
  default     = 6
}
variable "latency_datapoint" {
  description = "latency data points"
  type        = number
  default     = 5
}
variable "error_500_evaluation_periods" {
  description = "500 error data points value"
  type        = number
  default     = 2
}
variable "error_500_datapoint" {
  description = "500 error data points value"
  type        = number
  default     = 50
}
variable "ins_packetloss_evaluation_periods" {
  description = "evaluation period for instance packetloss metrics"
  type        = number
  default     = 10
}
variable "ins_packetloss_datapoint" {
  description = "data points for instance packetloss metrics"
  type        = number
  default     = 5
}
variable "ins_packetloss_threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 20
}
variable "callbreach_threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 10
}
variable "contact_flow_threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 10
}
variable "longestqueuewait_threshold" {
  description = "Value to compare against the specified statistic"
  type        = number
  default     = 1200
}
variable "connect_allowed_origins" {
  description = "amazon connect  origin names"
  type        = list(string)
  default     = ["https://test.com"]
}
variable "rds_secret_name" {
  description = "rds secret name"
  type        = string
  default     = "rds!db-bf428746-38ba-4728-b6d4-c45e1fd04392"
}
variable "insurance_identification_trigger_lambda_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}
variable "insurance_identification_trigger_lambda_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "insurance_identification_trigger_lambda_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 30
}
variable "insurance_identification_trigger_memory_size" {
  description = "memory size for lambda (in mbs)"
  type        = number
  default     = 128
}
variable "insurance_services_lambda_handler" {
  description = "Handler for lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}
variable "insurance_services_lambda_runtime" {
  description = "The run time for lambda"
  type        = string
  default     = "python3.10"
}

variable "insurance_services_lambda_timeout" {
  description = "The timeout time for lambda (in sec)"
  type        = number
  default     = 30
}
variable "insurance_services_memory_size" {
  description = "memory size for lambda (in mbs)"
  type        = number
  default     = 128
}
variable "base_domain" {
  description = "command center base domain name"
  type        = string
  default     = "genpactdemos.com"
}
variable "acm_cert_arn" {
  description = "acm certificate arn"
  type        = string
  default     = "5e44efe1-86d0-4bcd-b259-41ce929556c8"
}
variable "default_cidr" {
  description = "default CIDR block for alb access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "alias_bot_id" {
  type        = string
  default     = "MBLXMVWFPN/LIQE2Y5LBH"
}
```
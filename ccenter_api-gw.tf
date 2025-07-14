
resource "aws_api_gateway_deployment" "command_center_deployment" {

  rest_api_id = aws_api_gateway_rest_api.command_center.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.command_center.body,
      values(aws_api_gateway_resource.ivr_config_sub_resources)[*].id,
      #aws_api_gateway_resource.ivr_config_sub_resources.id,
      aws_api_gateway_method.add_ivr_config.id,
      aws_api_gateway_method.add_ivr_config_options.id,
      aws_api_gateway_integration.add_ivr_config_mock.id,
      aws_api_gateway_integration.add_ivr_config_lambda.id,
      aws_api_gateway_resource.delete_ivr_config.id,
      aws_api_gateway_method.delete_ivr_config.id,
      aws_api_gateway_method.delete_ivr_config_options.id,
      aws_api_gateway_integration.delete_ivr_config_mock.id,
      aws_api_gateway_integration.delete_ivr_config_lambda.id,
      aws_api_gateway_method.get_ivr_config.id,
      aws_api_gateway_method.get_ivr_config_options.id,
      aws_api_gateway_integration.get_ivr_config_mock.id,
      aws_api_gateway_integration.get_ivr_config_lambda.id,
      aws_api_gateway_resource.get_ivr_config_by_id.id,
      aws_api_gateway_method.get_ivr_config_by_id.id,
      aws_api_gateway_method.get_ivr_config_by_id_options.id,
      aws_api_gateway_integration.get_ivr_config_by_id_mock.id,
      aws_api_gateway_integration.get_ivr_config_by_id_lambda.id,
      aws_api_gateway_method.update_ivr_config.id,
      aws_api_gateway_method.update_ivr_config_options.id,
      aws_api_gateway_integration.update_ivr_config_mock.id,
      aws_api_gateway_integration.update_ivr_config_lambda.id,
      values(aws_api_gateway_resource.vm_personal_msg_sub_resources)[*].id,
      aws_api_gateway_method.add_vm_personal_msg.id,
      aws_api_gateway_method.add_vm_personal_msg_options.id,
      aws_api_gateway_integration.add_vm_personal_msg_mock.id,
      aws_api_gateway_integration.add_vm_personal_msg_lambda.id,
      aws_api_gateway_resource.delete_vm_personal_msg.id,
      aws_api_gateway_method.delete_vm_personal_msg.id,
      aws_api_gateway_method.delete_vm_personal_msg_options.id,
      aws_api_gateway_integration.delete_vm_personal_msg_mock.id,
      aws_api_gateway_integration.delete_vm_personal_msg_lambda.id,
      aws_api_gateway_method.get_vm_personal_msg.id,
      aws_api_gateway_method.get_vm_personal_msg_options.id,
      aws_api_gateway_integration.get_vm_personal_msg_mock.id,
      aws_api_gateway_integration.get_vm_personal_msg_lambda.id,
      aws_api_gateway_resource.get_vm_personal_msg_by_id.id,
      aws_api_gateway_method.get_vm_personal_msg_by_id.id,
      aws_api_gateway_method.get_vm_personal_msg_by_id_options.id,
      aws_api_gateway_integration.get_vm_personal_msg_by_id_mock.id,
      aws_api_gateway_integration.get_vm_personal_msg_by_id_lambda.id,
      aws_api_gateway_method.update_vm_personal_msg.id,
      aws_api_gateway_method.update_vm_personal_msg_options.id,
      aws_api_gateway_integration.update_vm_personal_msg_mock.id,
      aws_api_gateway_integration.update_vm_personal_msg_lambda.id,
      values(aws_api_gateway_resource.reconnect_mapping_sub_resources)[*].id,
      values(aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources)[*].id,
      aws_api_gateway_method.get_configuraion_reconnect.id,
      aws_api_gateway_method.get_configuraion_reconnect_options.id,
      aws_api_gateway_integration.get_configuraion_reconnect_mock.id,
      aws_api_gateway_integration.get_configuraion_reconnect_lambda.id,
      aws_api_gateway_resource.get_configuraion_reconnect_id.id,
      aws_api_gateway_method.get_configuraion_reconnect_id.id,
      aws_api_gateway_method.get_configuraion_reconnect_id_options.id,
      aws_api_gateway_integration.get_configuraion_reconnect_id_mock.id,
      aws_api_gateway_integration.get_configuraion_reconnect_id_lambda.id,
      aws_api_gateway_method.add_configuraion_reconnect.id,
      aws_api_gateway_method.add_configuraion_reconnect_options.id,
      aws_api_gateway_integration.add_configuraion_reconnect_mock.id,
      aws_api_gateway_integration.add_configuraion_reconnect_lambda.id,
      aws_api_gateway_resource.delete_configuraion_reconnect.id,
      aws_api_gateway_method.delete_configuraion_reconnect.id,
      aws_api_gateway_method.delete_configuraion_reconnect_options.id,
      aws_api_gateway_integration.delete_configuraion_reconnect_mock.id,
      aws_api_gateway_integration.delete_configuraion_reconnect_lambda.id,
      aws_api_gateway_method.update_configuration_reconnect.id,
      aws_api_gateway_method.update_configuration_reconnect_options.id,
      aws_api_gateway_integration.update_configuration_reconnect_mock.id,
      aws_api_gateway_integration.update_configuration_reconnect_lambda.id,
      aws_api_gateway_method.get_configuraion_cloudwatch_alarm.id,
      aws_api_gateway_method.get_configuraion_cloudwatch_alarm_options.id,
      aws_api_gateway_integration.get_configuraion_cloudwatch_alarm_mock.id,
      aws_api_gateway_integration.get_configuraion_cloudwatch_alarm_lambda.id,
      aws_api_gateway_resource.get_configuraion_cloudwatch_alarm_id.id,
      aws_api_gateway_method.get_configuraion_cloudwatch_alarm_id.id,
      aws_api_gateway_method.get_configuraion_cloudwatch_alarm_id_options.id,
      aws_api_gateway_integration.get_configuraion_cloudwatch_alarm_id_mock.id,
      aws_api_gateway_integration.get_configuraion_cloudwatch_alarm_id_lambda.id,
      aws_api_gateway_method.add_configuraion_cloudwatch_alarm.id,
      aws_api_gateway_method.add_configuraion_cloudwatch_alarm_options.id,
      aws_api_gateway_integration.add_configuraion_cloudwatch_alarm_mock.id,
      aws_api_gateway_integration.add_configuraion_cloudwatch_alarm_lambda.id,
      aws_api_gateway_resource.delete_configuraion_cloudwatch_alarm.id,
      aws_api_gateway_method.delete_configuraion_cloudwatch_alarm.id,
      aws_api_gateway_method.delete_configuraion_cloudwatch_alarm_options.id,
      aws_api_gateway_integration.delete_configuraion_cloudwatch_alarm_mock.id,
      aws_api_gateway_integration.delete_configuraion_cloudwatch_alarm_lambda.id,
      aws_api_gateway_method.update_configuration_cloudwatch_alarm.id,
      aws_api_gateway_method.update_configuration_cloudwatch_alarm_options.id,
      aws_api_gateway_integration.update_configuration_cloudwatch_alarm_mock.id,
      aws_api_gateway_integration.update_configuration_cloudwatch_alarm_lambda.id,


    ]))

  }
  depends_on = [aws_api_gateway_rest_api_policy.command_center_api]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "command_center_stage" {

  deployment_id = aws_api_gateway_deployment.command_center_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.command_center.id
  stage_name    = var.environment
  depends_on    = [aws_api_gateway_deployment.command_center_deployment]

  tags = merge(local.common_tags, {
    Name = "command-center-stage-${var.client}-${var.region}-${var.environment}"
  })
  lifecycle {
    ignore_changes = [
      cache_cluster_enabled

    ]
  }
}

resource "aws_api_gateway_rest_api" "command_center" {
  name        = "command-center-api-${var.client}-${var.region}-${var.environment}"
  description = "command-center"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.command_center.id]
  }
  tags = merge(local.common_tags, {
    Name = "command-center-${var.client}-${var.region}-${var.environment}"
  })
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_request_validator" "command_center" {
  name                        = "command-center"
  rest_api_id                 = aws_api_gateway_rest_api.command_center.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_resource" "top_level_resources" {
  for_each = toset([
    "agent-desktop-jwt-authorizer",
    "agent-desktop-rest-api-new",
    "api"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_rest_api.command_center.root_resource_id
  path_part   = each.value
}

# API sub-resources
resource "aws_api_gateway_resource" "api_sub_resources" {
  for_each = toset([
    "calllog",
    "contact-flow",
    "ctr",
    "destination-extension",
    "emergency-message",
    "fraudnumber",
    "holiday",
    "ivr",
    "postcallsurvey",
    "prompts-message",
    "queue",
    "queue-experience",
    "roles",
    "ivr-config",
    "vm-personal-msg",
    "sync",
    "toll-free-number",
    "users",
    "voicemail",
    "voicemail-mapping",
    "reconnect",
    "cloudwatch-alarm"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.top_level_resources["api"].id
  path_part   = each.value
}


resource "aws_api_gateway_resource" "calllog_getcalllogs" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["calllog"].id
  path_part   = "getcalllogs"
}

resource "aws_api_gateway_method" "calllog_getcalllogs_get" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.calllog_getcalllogs.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}


resource "aws_api_gateway_integration" "calllog_getcalllogs_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.calllog_getcalllogs.id
  http_method             = aws_api_gateway_method.calllog_getcalllogs_get.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


resource "aws_api_gateway_resource" "contact_flow_sub_resources" {
  for_each = toset([
    "add-contact-flow",
    "get-contact-flow-detail-by-id",
    "get-contact-flow-detail-pages",
    "get-contact-flow-details",

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["contact-flow"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "add_contact_flow" {
  rest_api_id   = aws_api_gateway_rest_api.command_center.id
  resource_id   = aws_api_gateway_resource.contact_flow_sub_resources["add-contact-flow"].id
  http_method   = "POST"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_contact_flow_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.contact_flow_sub_resources["add-contact-flow"].id
  http_method             = aws_api_gateway_method.add_contact_flow.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
resource "aws_api_gateway_method" "add_contact_flow_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.contact_flow_sub_resources["add-contact-flow"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_contact_flow_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.contact_flow_sub_resources["add-contact-flow"].id
  http_method             = aws_api_gateway_method.add_contact_flow_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_resource" "get_contact_flow_detail_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-detail-by-id"].id
  path_part   = "{contactFlowId}"
}

resource "aws_api_gateway_method" "get_contactflow_get_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_contact_flow_detail_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "getcontact_flow_id_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_contact_flow_detail_id.id
  http_method             = aws_api_gateway_method.get_contactflow_get_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "get_contact_flow_detail_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_contact_flow_detail_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "getcontact_flow_id_get_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_contact_flow_detail_id.id
  http_method             = aws_api_gateway_method.get_contact_flow_detail_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}


#/api/contact-flow/get-contact-flow-detail-pages


resource "aws_api_gateway_method" "get_contact_flow_detail-page" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-detail-pages"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

# Lambda integration for the /getcalllogs GET method
resource "aws_api_gateway_integration" "get_contact_flow_detail_by_page_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-detail-pages"].id
  http_method             = aws_api_gateway_method.get_contact_flow_detail-page.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
resource "aws_api_gateway_method" "get_contact_flow_detail-page_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-detail-pages"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_contact_flow_detail_by_page_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-detail-pages"].id
  http_method             = aws_api_gateway_method.get_contact_flow_detail-page_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

#/api/contact-flow/get-contact-flow-details

resource "aws_api_gateway_method" "get_contact_flow_details" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}


resource "aws_api_gateway_integration" "get_contact_flow_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-details"].id
  http_method             = aws_api_gateway_method.get_contact_flow_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "get_contact_flow_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_contact_flow_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.contact_flow_sub_resources["get-contact-flow-details"].id
  http_method             = aws_api_gateway_method.get_contact_flow_details_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

#/ctr

resource "aws_api_gateway_resource" "ctr_resource" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["ctr"].id
  path_part   = "putctr"
}

resource "aws_api_gateway_method" "ctr_post_method" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ctr_resource.id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}


resource "aws_api_gateway_integration" "ctr_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ctr_resource.id
  http_method             = aws_api_gateway_method.ctr_post_method.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#destination extension

resource "aws_api_gateway_resource" "destination_extension_sub_resources" {
  for_each = toset([
    "add-extenstion",
    "delete-extenstion",
    "get-all-destination-details",
    "get-destination-detail-by-extenstion-id",
    "update-extenstion"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["destination-extension"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "add_destination_extenstion" {
  rest_api_id   = aws_api_gateway_rest_api.command_center.id
  resource_id   = aws_api_gateway_resource.destination_extension_sub_resources["add-extenstion"].id
  http_method   = "POST"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "destination_extension_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.destination_extension_sub_resources["add-extenstion"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "destination_extension_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.destination_extension_sub_resources["add-extenstion"].id
  http_method             = aws_api_gateway_method.destination_extension_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "destination_extension_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.destination_extension_sub_resources["add-extenstion"].id
  http_method             = aws_api_gateway_method.add_destination_extenstion.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/destination-extension/delete-extenstion


resource "aws_api_gateway_resource" "delete_extensionid" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.destination_extension_sub_resources["delete-extenstion"].id
  path_part   = "{extensionId}"
}

resource "aws_api_gateway_method" "extension_id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.command_center.id
  resource_id   = aws_api_gateway_resource.delete_extensionid.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "extension_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_extensionid.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_extension_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_extensionid.id
  http_method             = aws_api_gateway_method.extension_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_extension_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_extensionid.id
  http_method             = aws_api_gateway_method.extension_id_delete.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/destination-extension/get-all-destination-details

resource "aws_api_gateway_method" "get_all_destination_details_get" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.destination_extension_sub_resources["get-all-destination-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_all_destination_extention_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.destination_extension_sub_resources["get-all-destination-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_all_destination_detail_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.destination_extension_sub_resources["get-all-destination-details"].id
  http_method             = aws_api_gateway_method.get_all_destination_extention_details_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_all_destination_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.destination_extension_sub_resources["get-all-destination-details"].id
  http_method             = aws_api_gateway_method.get_all_destination_details_get.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/destination-extension/get-destination-detail-by-extenstion-id



resource "aws_api_gateway_resource" "get_destination_extension_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.destination_extension_sub_resources["get-destination-detail-by-extenstion-id"].id
  path_part   = "{extensionId}"
}

resource "aws_api_gateway_method" "get_destination_detail_by_extension_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_destination_extension_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_destination_detail_by_extension_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_destination_extension_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}


resource "aws_api_gateway_integration" "get_destination_extension_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_destination_extension_id.id
  http_method             = aws_api_gateway_method.get_destination_detail_by_extension_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_destination_extension_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_destination_extension_id.id
  http_method             = aws_api_gateway_method.get_destination_detail_by_extension_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/destination-extension/update-extenstion

resource "aws_api_gateway_method" "update_extension_put" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.destination_extension_sub_resources["update-extenstion"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_extension_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.destination_extension_sub_resources["update-extenstion"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}


resource "aws_api_gateway_integration" "update_extenstion_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.destination_extension_sub_resources["update-extenstion"].id
  http_method             = aws_api_gateway_method.update_extension_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_extenstion_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.destination_extension_sub_resources["update-extenstion"].id
  http_method             = aws_api_gateway_method.update_extension_put.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/emergency-message


resource "aws_api_gateway_resource" "emergency_message_sub_resources" {
  for_each = toset([
    "add-emergency-message",
    "delete-emergency-message",
    "get-emergency-message-by-id",
    "get-emergency-messages",
    "update-emergency-message",

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["emergency-message"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "add_emergency_messagesn_post" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.emergency_message_sub_resources["add-emergency-message"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_emergency_messages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.emergency_message_sub_resources["add-emergency-message"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_emergency_messages_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.emergency_message_sub_resources["add-emergency-message"].id
  http_method             = aws_api_gateway_method.add_emergency_messages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_emergency_messages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.emergency_message_sub_resources["add-emergency-message"].id
  http_method             = aws_api_gateway_method.add_emergency_messagesn_post.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/emergency-message/delete-emergency-message


resource "aws_api_gateway_resource" "delete_emergency_messages_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.emergency_message_sub_resources["delete-emergency-message"].id
  path_part   = "{emergencyMessageId}"
}

resource "aws_api_gateway_method" "delete_emergency_messagesn_delete" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_emergency_messages_id.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_emergency_messages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_emergency_messages_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_emergency_messagess_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_emergency_messages_id.id
  http_method             = aws_api_gateway_method.delete_emergency_messages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_emergency_messages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_emergency_messages_id.id
  http_method             = aws_api_gateway_method.delete_emergency_messagesn_delete.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/emergency-message/get-emergency-message-by-id



resource "aws_api_gateway_resource" "get_emergency_messages_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.emergency_message_sub_resources["get-emergency-message-by-id"].id
  path_part   = "{emergencyMessageId}"
}

resource "aws_api_gateway_method" "get_emergency_messages_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_emergency_messages_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_emergency_messages_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_emergency_messages_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_emergency_messages_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_emergency_messages_id.id
  http_method             = aws_api_gateway_method.get_emergency_messages_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_emergency_messages_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_emergency_messages_id.id
  http_method             = aws_api_gateway_method.get_emergency_messages_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}



#get emergency messages

resource "aws_api_gateway_method" "get_emergency_messagesn_get" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.emergency_message_sub_resources["get-emergency-messages"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_emergency_messages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.emergency_message_sub_resources["get-emergency-messages"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_emergency_messages_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.emergency_message_sub_resources["get-emergency-messages"].id
  http_method             = aws_api_gateway_method.delete_emergency_messages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_emergency_messages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.emergency_message_sub_resources["get-emergency-messages"].id
  http_method             = aws_api_gateway_method.get_emergency_messagesn_get.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/emergency-message/update-emergency-message


resource "aws_api_gateway_method" "update_emergency_messagesn_put" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.emergency_message_sub_resources["update-emergency-message"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_emergency_messages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.emergency_message_sub_resources["update-emergency-message"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_emergency_messages_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.emergency_message_sub_resources["update-emergency-message"].id
  http_method             = aws_api_gateway_method.delete_emergency_messages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_emergency_messages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.emergency_message_sub_resources["update-emergency-message"].id
  http_method             = aws_api_gateway_method.update_emergency_messagesn_put.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#####/api/fraudnumber

resource "aws_api_gateway_resource" "fraud_number_sub_resources" {
  for_each = toset([
    "add-number",
    "delete-number",
    "get_number_by_id",
    "get-all-numbers",
    "update-number"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["fraudnumber"].id
  path_part   = each.value
}


resource "aws_api_gateway_method" "fraud_add_number" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_number_sub_resources["add-number"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "fraud_add_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_number_sub_resources["add-number"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "fraud_add_numbers_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_number_sub_resources["add-number"].id
  http_method             = aws_api_gateway_method.fraud_add_number_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "fraud_add_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_number_sub_resources["add-number"].id
  http_method             = aws_api_gateway_method.fraud_add_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/fraudnumber/delete-number/{fraud_id}

resource "aws_api_gateway_resource" "fraud_delete_number" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.fraud_number_sub_resources["delete-number"].id
  path_part   = "{fraud_id}"
}

resource "aws_api_gateway_method" "fraud_delete_number" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_delete_number.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "fraud_delete_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_delete_number.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "fraud_delete_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_delete_number.id
  http_method             = aws_api_gateway_method.fraud_delete_number_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "fraud_delete_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_delete_number.id
  http_method             = aws_api_gateway_method.fraud_delete_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#/api/fraudnumber/get_number_by_id

resource "aws_api_gateway_resource" "fraud_get_number_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.fraud_number_sub_resources["get_number_by_id"].id
  path_part   = "{fraud_number}"
}


resource "aws_api_gateway_method" "fraud_get_number_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_get_number_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "fraud_get_number_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_get_number_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "fraud_get_number_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_get_number_id.id
  http_method             = aws_api_gateway_method.fraud_get_number_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "fraud_get_number_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_get_number_id.id
  http_method             = aws_api_gateway_method.fraud_get_number_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#get all number
resource "aws_api_gateway_method" "fraud_get_all_number" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_number_sub_resources["get-all-numbers"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "fraud_get_all_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_number_sub_resources["get-all-numbers"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "fraud_get_all_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_number_sub_resources["get-all-numbers"].id
  http_method             = aws_api_gateway_method.fraud_get_all_number_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "fraud_get_all_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_number_sub_resources["get-all-numbers"].id
  http_method             = aws_api_gateway_method.fraud_get_all_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/fraudnumber/update-number

resource "aws_api_gateway_method" "fraud_update_number" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_number_sub_resources["update-number"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "fraud_update_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.fraud_number_sub_resources["update-number"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "fraud_update_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_number_sub_resources["update-number"].id
  http_method             = aws_api_gateway_method.fraud_update_number_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "fraud_update_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.fraud_number_sub_resources["update-number"].id
  http_method             = aws_api_gateway_method.fraud_update_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#holiday

resource "aws_api_gateway_resource" "holiday_sub_resources" {
  for_each = toset([
    "add-holiday",
    "delete-holiday",
    "get-holiday-detail-by-id",
    "get-holiday-details",
    "update-holiday"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["holiday"].id
  path_part   = each.value
}


resource "aws_api_gateway_method" "add_holiday" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.holiday_sub_resources["add-holiday"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_holiday_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.holiday_sub_resources["add-holiday"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_holiday_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.holiday_sub_resources["add-holiday"].id
  http_method             = aws_api_gateway_method.add_holiday_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_holiday_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.holiday_sub_resources["add-holiday"].id
  http_method             = aws_api_gateway_method.add_holiday.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/holiday/delete-holiday

resource "aws_api_gateway_resource" "delete_holiday" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.holiday_sub_resources["delete-holiday"].id
  path_part   = "{holidayId}"
}

resource "aws_api_gateway_method" "delete_holiday" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_holiday.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_holiday_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_holiday.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_holiday_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_holiday.id
  http_method             = aws_api_gateway_method.delete_holiday_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_holiday_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_holiday.id
  http_method             = aws_api_gateway_method.delete_holiday.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/holiday/get-holiday-detail-by-id


resource "aws_api_gateway_resource" "get_holiday_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.holiday_sub_resources["get-holiday-detail-by-id"].id
  path_part   = "{holidayId}"
}

resource "aws_api_gateway_method" "get_holiday_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_holiday_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_holiday_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_holiday_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_holiday_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_holiday_by_id.id
  http_method             = aws_api_gateway_method.get_holiday_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_holiday_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_holiday_by_id.id
  http_method             = aws_api_gateway_method.get_holiday_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/holiday/get-holiday-details

resource "aws_api_gateway_method" "get_holiday_details" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.holiday_sub_resources["get-holiday-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_holiday_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.holiday_sub_resources["get-holiday-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_holiday_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.holiday_sub_resources["get-holiday-details"].id
  http_method             = aws_api_gateway_method.get_holiday_details_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_holiday_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.holiday_sub_resources["get-holiday-details"].id
  http_method             = aws_api_gateway_method.get_holiday_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/holiday/update-holiday

resource "aws_api_gateway_method" "update_holiday" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.holiday_sub_resources["update-holiday"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_holiday_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.holiday_sub_resources["update-holiday"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_holiday_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.holiday_sub_resources["update-holiday"].id
  http_method             = aws_api_gateway_method.update_holiday_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_holiday_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.holiday_sub_resources["update-holiday"].id
  http_method             = aws_api_gateway_method.update_holiday.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/ivr
resource "aws_api_gateway_resource" "ivr_sub_resources" {
  for_each = toset([
    "getIvrItem",
    "getrecording",
    "recordinglisten"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["ivr"].id
  path_part   = each.value
}

#/api/ivr/getIvrItem

resource "aws_api_gateway_method" "getivritem" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_sub_resources["getIvrItem"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "getivritem_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_sub_resources["getIvrItem"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "getivritem_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_sub_resources["getIvrItem"].id
  http_method             = aws_api_gateway_method.getivritem_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "getivritem_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_sub_resources["getIvrItem"].id
  http_method             = aws_api_gateway_method.getivritem.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/ivr/getrecording

resource "aws_api_gateway_method" "getrecording" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_sub_resources["getrecording"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "getrecording_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_sub_resources["getrecording"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "getrecording_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_sub_resources["getrecording"].id
  http_method             = aws_api_gateway_method.getrecording_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "getrecording_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_sub_resources["getrecording"].id
  http_method             = aws_api_gateway_method.getrecording.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/ivr/recordinglisten


resource "aws_api_gateway_method" "recordinglisten" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_sub_resources["recordinglisten"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "recordinglisten_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_sub_resources["recordinglisten"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "recordinglisten_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_sub_resources["recordinglisten"].id
  http_method             = aws_api_gateway_method.recordinglisten_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "recordinglisten_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_sub_resources["recordinglisten"].id
  http_method             = aws_api_gateway_method.recordinglisten.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


# /api/postcallsurvey

resource "aws_api_gateway_resource" "postcallsurvey_sub_resources" {
  for_each = toset([
    "add-result",
    "add-survey",
    "delete-survey",
    "get-result",
    "get-survey",
    "get-survey-by-id",
    "get-survey-details",
    "update-survey"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["postcallsurvey"].id
  path_part   = each.value
}

#/api/postcallsurvey/add-result


resource "aws_api_gateway_method" "postcall_add_result" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["add-result"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcall_add_result_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["add-result"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcall_add_result_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["add-result"].id
  http_method             = aws_api_gateway_method.postcall_add_result_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcall_add_result_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["add-result"].id
  http_method             = aws_api_gateway_method.postcall_add_result.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/postcallsurvey/add-survey


resource "aws_api_gateway_method" "postcall_add_survey" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["add-survey"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcall_add_survey_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["add-survey"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcall_add_survey_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["add-survey"].id
  http_method             = aws_api_gateway_method.postcall_add_survey_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcall_add_survey_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["add-survey"].id
  http_method             = aws_api_gateway_method.postcall_add_survey.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/postcallsurvey/delete-survey/{survey_id}


resource "aws_api_gateway_resource" "postcalldelete_survey" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.postcallsurvey_sub_resources["delete-survey"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcall_delete_survey" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcalldelete_survey.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcall_delete_survey_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcalldelete_survey.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcall_delete_survey_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcalldelete_survey.id
  http_method             = aws_api_gateway_method.postcall_delete_survey_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcall_delete_survey_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcalldelete_survey.id
  http_method             = aws_api_gateway_method.postcall_delete_survey.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/postcallsurvey/get-result/{survey_id}


resource "aws_api_gateway_resource" "postcallget_result" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.postcallsurvey_sub_resources["get-result"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcallget_result" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallget_result.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcallget_result_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallget_result.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcallget_result_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallget_result.id
  http_method             = aws_api_gateway_method.postcallget_result_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcallget_result_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallget_result.id
  http_method             = aws_api_gateway_method.postcallget_result.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/postcallsurvey/get-survey

resource "aws_api_gateway_method" "postcallget_survey" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["get-survey"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcallget_survey_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["get-survey"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcallget_survey_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["get-survey"].id
  http_method             = aws_api_gateway_method.postcallget_survey_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcallget_survey_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["get-survey"].id
  http_method             = aws_api_gateway_method.postcallget_survey.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/postcallsurvey/get-survey-by-id/{survey_id}

resource "aws_api_gateway_resource" "postcallget_survey_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.postcallsurvey_sub_resources["get-survey-by-id"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcallget_survey_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallget_survey_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcallget_survey_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallget_survey_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcallget_survey_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallget_survey_id.id
  http_method             = aws_api_gateway_method.postcallget_survey_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcallget_survey_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallget_survey_id.id
  http_method             = aws_api_gateway_method.postcallget_survey_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/postcallsurvey/get-survey-details/{survey_id}
resource "aws_api_gateway_resource" "postcallget_survey_details" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.postcallsurvey_sub_resources["get-survey-details"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcallget_survey_details" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallget_survey_details.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcallget_survey_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallget_survey_details.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcallget_survey_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallget_survey_details.id
  http_method             = aws_api_gateway_method.postcallget_survey_details_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcallget_survey_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallget_survey_details.id
  http_method             = aws_api_gateway_method.postcallget_survey_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/postcallsurvey/update-survey

resource "aws_api_gateway_method" "postcallupdate_survey" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["update-survey"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "postcallupdate_survey_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.postcallsurvey_sub_resources["update-survey"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcallupdate_survey_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["update-survey"].id
  http_method             = aws_api_gateway_method.postcallupdate_survey_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcallupdate_survey_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.postcallsurvey_sub_resources["update-survey"].id
  http_method             = aws_api_gateway_method.postcallupdate_survey.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


resource "aws_api_gateway_resource" "prompts-message_sub_resources" {
  for_each = toset([
    "add-prompts-message",
    "delete-prompts-message",
    "get-message",
    "get-prompts-message-pages",
    "get-prompts-messages",
    "get-prompts-messages-by-id",
    "update-prompts-message",

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["prompts-message"].id
  path_part   = each.value
}

#/api/prompts-message/add-prompts-message

resource "aws_api_gateway_method" "add_prompts_message" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["add-prompts-message"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_prompts_message_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["add-prompts-message"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_prompts_message_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["add-prompts-message"].id
  http_method             = aws_api_gateway_method.add_prompts_message_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_prompts_message_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["add-prompts-message"].id
  http_method             = aws_api_gateway_method.add_prompts_message.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/prompts-message/delete-prompts-message/{promptsMessageId}

resource "aws_api_gateway_resource" "delete_prompts_message" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.prompts-message_sub_resources["delete-prompts-message"].id
  path_part   = "{promptsMessageId}"
}


resource "aws_api_gateway_method" "delete_prompts_message" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_prompts_message.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_prompts_message_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_prompts_message.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_prompts_message_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_prompts_message.id
  http_method             = aws_api_gateway_method.delete_prompts_message_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_prompts_message_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_prompts_message.id
  http_method             = aws_api_gateway_method.delete_prompts_message.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/prompts-message/get-message

resource "aws_api_gateway_method" "get_prompts_message" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["get-message"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_prompts_message_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["get-message"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_prompts_message_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["get-message"].id
  http_method             = aws_api_gateway_method.get_prompts_message_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_prompts_message_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["get-message"].id
  http_method             = aws_api_gateway_method.get_prompts_message.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/prompts-message/get-prompts-message-pages/{pageId}


resource "aws_api_gateway_resource" "get_prompts_message_pages" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.prompts-message_sub_resources["get-prompts-message-pages"].id
  path_part   = "{pageId}"
}


resource "aws_api_gateway_method" "get_prompts_message_pages" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_prompts_message_pages.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_prompts_message_pages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_prompts_message_pages.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "postcallget_survey_page_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_prompts_message_pages.id
  http_method             = aws_api_gateway_method.get_prompts_message_pages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "postcallget_survey_page_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_prompts_message_pages.id
  http_method             = aws_api_gateway_method.get_prompts_message_pages.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/prompts-message/get-prompts-messages


resource "aws_api_gateway_method" "get_prompts_messages" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["get-prompts-messages"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_prompts_messages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["get-prompts-messages"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_prompts_messages_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["get-prompts-messages"].id
  http_method             = aws_api_gateway_method.get_prompts_messages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_prompts_messages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["get-prompts-messages"].id
  http_method             = aws_api_gateway_method.get_prompts_messages.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
##/api/prompts-message/get-prompts-messages-by-id/{promptsMessageId}

resource "aws_api_gateway_resource" "get_prompts_message_pages_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.prompts-message_sub_resources["get-prompts-messages-by-id"].id
  path_part   = "{promptsMessageId}"
}


resource "aws_api_gateway_method" "get_prompts_message_pages_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_prompts_message_pages_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_prompts_message_pages_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_prompts_message_pages_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_prompts_message_pages_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_prompts_message_pages_id.id
  http_method             = aws_api_gateway_method.get_prompts_message_pages_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_prompts_message_pages_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_prompts_message_pages_id.id
  http_method             = aws_api_gateway_method.get_prompts_message_pages_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/prompts-message/update-prompts-message
resource "aws_api_gateway_method" "update_prompts_message" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["update-prompts-message"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_prompts_message_option" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.prompts-message_sub_resources["update-prompts-message"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_prompts_message_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["update-prompts-message"].id
  http_method             = aws_api_gateway_method.update_prompts_message_option.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_prompts_message_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.prompts-message_sub_resources["update-prompts-message"].id
  http_method             = aws_api_gateway_method.update_prompts_message.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


resource "aws_api_gateway_resource" "queue_sub_resources" {
  for_each = toset([
    "add-queue",
    "get-queue-detail-by-id",
    "get-queue-details",
    "get-queue-details-pages"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["queue"].id
  path_part   = each.value
}


##/api/queue/add-queue
resource "aws_api_gateway_method" "add_queue" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queue_sub_resources["add-queue"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_queue_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queue_sub_resources["add-queue"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_queue_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queue_sub_resources["add-queue"].id
  http_method             = aws_api_gateway_method.add_queue_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_queue_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queue_sub_resources["add-queue"].id
  http_method             = aws_api_gateway_method.add_queue.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/queue/get-queue-detail-by-id/{queueId}

resource "aws_api_gateway_resource" "get_queue_detail_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.queue_sub_resources["get-queue-detail-by-id"].id
  path_part   = "{queueId}"
}


resource "aws_api_gateway_method" "get_queue_detail_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_queue_detail_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_queue_detail_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_queue_detail_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_queue_detail_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_queue_detail_by_id.id
  http_method             = aws_api_gateway_method.get_queue_detail_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_queue_detail_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_queue_detail_by_id.id
  http_method             = aws_api_gateway_method.get_queue_detail_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/queue/get-queue-details

resource "aws_api_gateway_method" "get_queue_detail" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queue_sub_resources["get-queue-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_queue_detail_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queue_sub_resources["get-queue-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_queue_detail_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queue_sub_resources["get-queue-details"].id
  http_method             = aws_api_gateway_method.get_queue_detail_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_queue_detail_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queue_sub_resources["get-queue-details"].id
  http_method             = aws_api_gateway_method.get_queue_detail.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/queue/get-queue-details-pages

resource "aws_api_gateway_method" "get_queue_detail_pages" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queue_sub_resources["get-queue-details-pages"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_queue_detail_pages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queue_sub_resources["get-queue-details-pages"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_queue_detail_pages_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queue_sub_resources["get-queue-details-pages"].id
  http_method             = aws_api_gateway_method.get_queue_detail_pages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_queue_detail_pages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queue_sub_resources["get-queue-details-pages"].id
  http_method             = aws_api_gateway_method.get_queue_detail_pages.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/queue-experience/get-details

resource "aws_api_gateway_resource" "queu_experience_sub_resources" {
  for_each = toset([
    "get-details"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["queue-experience"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "get_queue_exp_detail" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queu_experience_sub_resources["get-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_queue_exp_detail_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.queu_experience_sub_resources["get-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_queue_exp_detail_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queu_experience_sub_resources["get-details"].id
  http_method             = aws_api_gateway_method.get_queue_exp_detail_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_queue_exp_detail_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.queu_experience_sub_resources["get-details"].id
  http_method             = aws_api_gateway_method.get_queue_exp_detail.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


##/api/roles/get-roles


resource "aws_api_gateway_resource" "roles_sub_resources" {
  for_each = toset([
    "get-roles"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["roles"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "get_roles" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.roles_sub_resources["get-roles"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_roles_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.roles_sub_resources["get-roles"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_roles_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.roles_sub_resources["get-roles"].id
  http_method             = aws_api_gateway_method.get_roles_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_roles_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.roles_sub_resources["get-roles"].id
  http_method             = aws_api_gateway_method.get_roles.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/ivr-config

resource "aws_api_gateway_resource" "ivr_config_sub_resources" {
  for_each = toset([
    "add-ivr-config",
    "delete-ivr-config",
    "get-ivr-config",
    "get-ivr-config-by-id",
    "update-ivr-config"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["ivr-config"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "add_ivr_config" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_config_sub_resources["add-ivr-config"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_ivr_config_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_config_sub_resources["add-ivr-config"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_ivr_config_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_config_sub_resources["add-ivr-config"].id
  http_method             = aws_api_gateway_method.add_ivr_config_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_ivr_config_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_config_sub_resources["add-ivr-config"].id
  http_method             = aws_api_gateway_method.add_ivr_config.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/ivr-config/delete-ivr-config/{selfServeId}
resource "aws_api_gateway_resource" "delete_ivr_config" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.ivr_config_sub_resources["delete-ivr-config"].id
  path_part   = "{selfServeId}"
}


resource "aws_api_gateway_method" "delete_ivr_config" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_ivr_config.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_ivr_config_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_ivr_config.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_ivr_config_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_ivr_config.id
  http_method             = aws_api_gateway_method.delete_ivr_config_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_ivr_config_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_ivr_config.id
  http_method             = aws_api_gateway_method.delete_ivr_config.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/ivr-config/get-ivr-config
resource "aws_api_gateway_method" "get_ivr_config" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_config_sub_resources["get-ivr-config"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_ivr_config_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_config_sub_resources["get-ivr-config"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_ivr_config_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_config_sub_resources["get-ivr-config"].id
  http_method             = aws_api_gateway_method.get_ivr_config_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_ivr_config_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_config_sub_resources["get-ivr-config"].id
  http_method             = aws_api_gateway_method.get_ivr_config.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/ivr-config/get-ivr-config-by-id/{selfServeId}

resource "aws_api_gateway_resource" "get_ivr_config_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.ivr_config_sub_resources["get-ivr-config-by-id"].id
  path_part   = "{selfServeId}"
}


resource "aws_api_gateway_method" "get_ivr_config_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_ivr_config_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_ivr_config_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_ivr_config_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_ivr_config_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_ivr_config_by_id.id
  http_method             = aws_api_gateway_method.get_ivr_config_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_ivr_config_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_ivr_config_by_id.id
  http_method             = aws_api_gateway_method.get_ivr_config_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
# /api/ivr-config/update-ivr-config
resource "aws_api_gateway_method" "update_ivr_config" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_config_sub_resources["update-ivr-config"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_ivr_config_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.ivr_config_sub_resources["update-ivr-config"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_ivr_config_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_config_sub_resources["update-ivr-config"].id
  http_method             = aws_api_gateway_method.update_ivr_config_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_ivr_config_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.ivr_config_sub_resources["update-ivr-config"].id
  http_method             = aws_api_gateway_method.update_ivr_config.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/vm-personal-msg

resource "aws_api_gateway_resource" "vm_personal_msg_sub_resources" {
  for_each = toset([
    "add-vm-personal-msg",
    "delete-vm-personal-msg",
    "get-vm-personal-msg",
    "get-vm-personal-msg-by-id",
    "update-vm-personal-msg"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["vm-personal-msg"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "add_vm_personal_msg" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.vm_personal_msg_sub_resources["add-vm-personal-msg"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_vm_personal_msg_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.vm_personal_msg_sub_resources["add-vm-personal-msg"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_vm_personal_msg_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.vm_personal_msg_sub_resources["add-vm-personal-msg"].id
  http_method             = aws_api_gateway_method.add_vm_personal_msg_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_vm_personal_msg_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.vm_personal_msg_sub_resources["add-vm-personal-msg"].id
  http_method             = aws_api_gateway_method.add_vm_personal_msg.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/vm-personal-msg/delete-vm-personal-msg/{csrId}
resource "aws_api_gateway_resource" "delete_vm_personal_msg" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.vm_personal_msg_sub_resources["delete-vm-personal-msg"].id
  path_part   = "{csrId}"
}


resource "aws_api_gateway_method" "delete_vm_personal_msg" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_vm_personal_msg.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_vm_personal_msg_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_vm_personal_msg.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_vm_personal_msg_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_vm_personal_msg.id
  http_method             = aws_api_gateway_method.delete_vm_personal_msg_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_vm_personal_msg_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_vm_personal_msg.id
  http_method             = aws_api_gateway_method.delete_vm_personal_msg.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

# /api/vm-personal-msg/get-vm-personal-msg

resource "aws_api_gateway_method" "get_vm_personal_msg" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.vm_personal_msg_sub_resources["get-vm-personal-msg"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_vm_personal_msg_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.vm_personal_msg_sub_resources["get-vm-personal-msg"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_vm_personal_msg_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.vm_personal_msg_sub_resources["get-vm-personal-msg"].id
  http_method             = aws_api_gateway_method.get_vm_personal_msg_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_vm_personal_msg_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.vm_personal_msg_sub_resources["get-vm-personal-msg"].id
  http_method             = aws_api_gateway_method.get_vm_personal_msg.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/vm-personal-msg/get-vm-personal-msg-by-id/{csrId}

resource "aws_api_gateway_resource" "get_vm_personal_msg_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.vm_personal_msg_sub_resources["get-vm-personal-msg-by-id"].id
  path_part   = "{csrId}"
}


resource "aws_api_gateway_method" "get_vm_personal_msg_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_vm_personal_msg_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_vm_personal_msg_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_vm_personal_msg_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_vm_personal_msg_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_vm_personal_msg_by_id.id
  http_method             = aws_api_gateway_method.get_vm_personal_msg_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_vm_personal_msg_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_vm_personal_msg_by_id.id
  http_method             = aws_api_gateway_method.get_vm_personal_msg_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
# /api/vm-personal-msg/update-vm-personal-msg
resource "aws_api_gateway_method" "update_vm_personal_msg" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.vm_personal_msg_sub_resources["update-vm-personal-msg"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_vm_personal_msg_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.vm_personal_msg_sub_resources["update-vm-personal-msg"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_vm_personal_msg_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.vm_personal_msg_sub_resources["update-vm-personal-msg"].id
  http_method             = aws_api_gateway_method.update_vm_personal_msg_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_vm_personal_msg_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.vm_personal_msg_sub_resources["update-vm-personal-msg"].id
  http_method             = aws_api_gateway_method.update_vm_personal_msg.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/sync
resource "aws_api_gateway_method" "api_sync" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.api_sub_resources["sync"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "api_sync_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.api_sub_resources["sync"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "api_sync_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.api_sub_resources["sync"].id
  http_method             = aws_api_gateway_method.api_sync_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "api_sync_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.api_sub_resources["sync"].id
  http_method             = aws_api_gateway_method.api_sync.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
##/api/toll-free-number/add-toll-free-number

resource "aws_api_gateway_resource" "toll_free_number_sub_resources" {
  for_each = toset([
    "add-toll-free-number",
    "get-toll-free-number-detail-by-id",
    "get-toll-free-number-details-pages",
    "get-toll-free-numbers"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["toll-free-number"].id
  path_part   = each.value
}


resource "aws_api_gateway_method" "add_toll_free_number" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.toll_free_number_sub_resources["add-toll-free-number"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_toll_free_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.toll_free_number_sub_resources["add-toll-free-number"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_toll_free_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.toll_free_number_sub_resources["add-toll-free-number"].id
  http_method             = aws_api_gateway_method.add_toll_free_number_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_toll_free_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.toll_free_number_sub_resources["add-toll-free-number"].id
  http_method             = aws_api_gateway_method.add_toll_free_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


##/api/toll-free-number/get-toll-free-number-detail-by-id/{tollFreeNumberId}
resource "aws_api_gateway_resource" "add_toll_free_number_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-number-detail-by-id"].id
  path_part   = "{tollFreeNumberId}"
}


resource "aws_api_gateway_method" "add_toll_free_number_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.add_toll_free_number_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_toll_free_number_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.add_toll_free_number_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_toll_free_number_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.add_toll_free_number_by_id.id
  http_method             = aws_api_gateway_method.add_toll_free_number_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_toll_free_number_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.add_toll_free_number_by_id.id
  http_method             = aws_api_gateway_method.add_toll_free_number_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


##/api/toll-free-number/get-toll-free-number-details-pages

resource "aws_api_gateway_method" "add_toll_free_number_pages" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-number-details-pages"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_toll_free_number_pages_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-number-details-pages"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_toll_free_number_pages_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-number-details-pages"].id
  http_method             = aws_api_gateway_method.add_toll_free_number_pages_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_toll_free_number_pages_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-number-details-pages"].id
  http_method             = aws_api_gateway_method.add_toll_free_number_pages.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/toll-free-number/get-toll-free-numbers

resource "aws_api_gateway_method" "get_toll_free_number" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-numbers"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_toll_free_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-numbers"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_toll_free_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-numbers"].id
  http_method             = aws_api_gateway_method.get_toll_free_number_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_toll_free_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-numbers"].id
  http_method             = aws_api_gateway_method.get_toll_free_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/toll-free-number/get-toll-free-numbers/{tollFreeNumberId}

resource "aws_api_gateway_resource" "get_toll_free_numbers" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.toll_free_number_sub_resources["get-toll-free-numbers"].id
  path_part   = "{tollFreeNumberId}"
}


resource "aws_api_gateway_method" "get_toll_free_numbers" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_toll_free_numbers.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_toll_free_numbers_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_toll_free_numbers.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_toll_free_numbers_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_toll_free_numbers.id
  http_method             = aws_api_gateway_method.get_toll_free_numbers_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_toll_free_numbers_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_toll_free_numbers.id
  http_method             = aws_api_gateway_method.get_toll_free_numbers.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/users/add-user
resource "aws_api_gateway_resource" "users_sub_resources" {
  for_each = toset([
    "add-user",
    "delete-user",
    "get-agent-details-options",
    "get-user-details",
    "get-userdetail-by-id",
    "update-user",
    "user-list"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["users"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "add_user" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["add-user"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_user_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["add-user"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_user_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["add-user"].id
  http_method             = aws_api_gateway_method.add_user_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_user_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["add-user"].id
  http_method             = aws_api_gateway_method.add_user.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/users/delete-user/{userId}
resource "aws_api_gateway_resource" "delete_users" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.users_sub_resources["delete-user"].id
  path_part   = "{userId}"
}


resource "aws_api_gateway_method" "delete_users" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_users.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_users_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_users.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_users_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_users.id
  http_method             = aws_api_gateway_method.delete_users_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_users_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_users.id
  http_method             = aws_api_gateway_method.delete_users.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/users/get-agent-details-options

resource "aws_api_gateway_method" "get_agent_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["get-agent-details-options"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_agent_details_options_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["get-agent-details-options"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_agent_details_options_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["get-agent-details-options"].id
  http_method             = aws_api_gateway_method.get_agent_details_options_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_agent_details_options_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["get-agent-details-options"].id
  http_method             = aws_api_gateway_method.get_agent_details_options.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/users/get-user-details


resource "aws_api_gateway_method" "get_user_details" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["get-user-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_user_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["get-user-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_user_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["get-user-details"].id
  http_method             = aws_api_gateway_method.get_user_details_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_user_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["get-user-details"].id
  http_method             = aws_api_gateway_method.get_user_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/users/get-userdetail-by-id/{userId}

resource "aws_api_gateway_resource" "get_user_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.users_sub_resources["get-userdetail-by-id"].id
  path_part   = "{userId}"
}


resource "aws_api_gateway_method" "get_user_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_user_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_user_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_user_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_user_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_user_by_id.id
  http_method             = aws_api_gateway_method.get_user_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_user_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_user_by_id.id
  http_method             = aws_api_gateway_method.get_user_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##/api/users/update-user/{userId}

resource "aws_api_gateway_resource" "update_users" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.users_sub_resources["update-user"].id
  path_part   = "{userId}"
}


resource "aws_api_gateway_method" "update_users" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.update_users.id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_users_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.update_users.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_users_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.update_users.id
  http_method             = aws_api_gateway_method.update_users_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_users_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.update_users.id
  http_method             = aws_api_gateway_method.update_users.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
##/api/users/user-list


resource "aws_api_gateway_method" "list_users" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["user-list"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "list_users_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.users_sub_resources["user-list"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "list_users_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["user-list"].id
  http_method             = aws_api_gateway_method.list_users_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "list_users_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.users_sub_resources["user-list"].id
  http_method             = aws_api_gateway_method.list_users.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


resource "aws_api_gateway_resource" "voicemail_sub_resources" {
  for_each = toset([
    "add-voicemail-delivery-setup",
    "delete-voicemail-delivery-setup",
    "get-all-voicemail-delivery-setups",
    "get-voicemail-delivery-setups-by-aws-id",
    "get-voicemail-delivery-setups-by-id",
    "getrecording",
    "getrecording_new",
    "getvoicemailItem",
    "recordinglisten",
    "update-voicemail-delivery-setup"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["voicemail"].id
  path_part   = each.value
}

#/api/voicemail/add-voicemail-delivery-setup

resource "aws_api_gateway_method" "add_voicemail_delivery_setup" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["add-voicemail-delivery-setup"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_voicemail_delivery_setup_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["add-voicemail-delivery-setup"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_voicemail_delivery_setup_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["add-voicemail-delivery-setup"].id
  http_method             = aws_api_gateway_method.add_voicemail_delivery_setup_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_voicemail_delivery_setup_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["add-voicemail-delivery-setup"].id
  http_method             = aws_api_gateway_method.add_voicemail_delivery_setup.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/voicemail/delete-voicemail-delivery-setup/{voiceMailDeliveryId}
resource "aws_api_gateway_resource" "delete_voicemail_delivery_setup" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.voicemail_sub_resources["delete-voicemail-delivery-setup"].id
  path_part   = "{voiceMailDeliveryId}"
}


resource "aws_api_gateway_method" "delete_voicemail_delivery_setup" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_voicemail_delivery_setup.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_voicemail_delivery_setup_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_voicemail_delivery_setup.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_voicemail_delivery_setup_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_voicemail_delivery_setup.id
  http_method             = aws_api_gateway_method.delete_voicemail_delivery_setup_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_voicemail_delivery_setup_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_voicemail_delivery_setup.id
  http_method             = aws_api_gateway_method.delete_voicemail_delivery_setup.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/voicemail/get-all-voicemail-delivery-setups
resource "aws_api_gateway_method" "get_all_voicemail_delivery_setups" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["get-all-voicemail-delivery-setups"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_all_voicemail_delivery_setups_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["get-all-voicemail-delivery-setups"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_all_voicemail_delivery_setups_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["get-all-voicemail-delivery-setups"].id
  http_method             = aws_api_gateway_method.get_all_voicemail_delivery_setups_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_all_voicemail_delivery_setups_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["get-all-voicemail-delivery-setups"].id
  http_method             = aws_api_gateway_method.get_all_voicemail_delivery_setups.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#/api/voicemail/get-voicemail-delivery-setups-by-aws-id

resource "aws_api_gateway_method" "get_voicemail_delivery_setups_by_aws_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["get-voicemail-delivery-setups-by-aws-id"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_voicemail_delivery_setups_by_aws_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["get-voicemail-delivery-setups-by-aws-id"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_voicemail_delivery_setups_by_aws_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["get-voicemail-delivery-setups-by-aws-id"].id
  http_method             = aws_api_gateway_method.get_voicemail_delivery_setups_by_aws_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_voicemail_delivery_setups_by_aws_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["get-voicemail-delivery-setups-by-aws-id"].id
  http_method             = aws_api_gateway_method.get_voicemail_delivery_setups_by_aws_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#/api/voicemail/get-voicemail-delivery-setups-by-id/{voiceMailDeliveryId}
resource "aws_api_gateway_resource" "get_voicemail_delivery_setups_by_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.voicemail_sub_resources["get-voicemail-delivery-setups-by-id"].id
  path_part   = "{voiceMailDeliveryId}"
}


resource "aws_api_gateway_method" "get_voicemail_delivery_setups_by_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_voicemail_delivery_setups_by_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_voicemail_delivery_setups_by_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_voicemail_delivery_setups_by_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_voicemail_delivery_setups_by_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_voicemail_delivery_setups_by_id.id
  http_method             = aws_api_gateway_method.get_voicemail_delivery_setups_by_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_voicemail_delivery_setups_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_voicemail_delivery_setups_by_id.id
  http_method             = aws_api_gateway_method.get_voicemail_delivery_setups_by_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#/api/voicemail/getrecording


resource "aws_api_gateway_method" "voicemail_getrecording" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["getrecording"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "voicemail_getrecording_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["getrecording"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "voicemail_getrecording_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["getrecording"].id
  http_method             = aws_api_gateway_method.voicemail_getrecording_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "voicemail_getrecording_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["getrecording"].id
  http_method             = aws_api_gateway_method.voicemail_getrecording.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#/api/voicemail/getrecording_new/{recordingId}

resource "aws_api_gateway_resource" "getrecording_new" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.voicemail_sub_resources["getrecording_new"].id
  path_part   = "{recordingId}"
}


resource "aws_api_gateway_method" "getrecording_new" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.getrecording_new.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "getrecording_new_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.getrecording_new.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "getrecording_new_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.getrecording_new.id
  http_method             = aws_api_gateway_method.getrecording_new_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "getrecording_new_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.getrecording_new.id
  http_method             = aws_api_gateway_method.getrecording_new.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#/api/voicemail/getvoicemailItem


resource "aws_api_gateway_method" "getvoicemailItem" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["getvoicemailItem"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "getvoicemailItem_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["getvoicemailItem"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "getvoicemailItem_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["getvoicemailItem"].id
  http_method             = aws_api_gateway_method.getvoicemailItem_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "getvoicemailItem_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["getvoicemailItem"].id
  http_method             = aws_api_gateway_method.getvoicemailItem.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#/api/voicemail/recordinglisten


resource "aws_api_gateway_method" "voicemail_recordinglisten" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["recordinglisten"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "voicemail_recordinglisten_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["recordinglisten"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "voicemail_recordinglisten_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["recordinglisten"].id
  http_method             = aws_api_gateway_method.voicemail_recordinglisten_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "voicemail_recordinglisten_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["recordinglisten"].id
  http_method             = aws_api_gateway_method.voicemail_recordinglisten.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
#/api/voicemail/update-voicemail-delivery-setup


resource "aws_api_gateway_method" "update_voicemail_delivery_setup" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["update-voicemail-delivery-setup"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_voicemail_delivery_setup_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail_sub_resources["update-voicemail-delivery-setup"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_voicemail_delivery_setup_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["update-voicemail-delivery-setup"].id
  http_method             = aws_api_gateway_method.update_voicemail_delivery_setup_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_voicemail_delivery_setup_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail_sub_resources["update-voicemail-delivery-setup"].id
  http_method             = aws_api_gateway_method.update_voicemail_delivery_setup.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_resource" "voicemail-mapping_sub_resources" {
  for_each = toset([
    "add-agent-voicemail",
    "delete-agent-voicemail",
    "get-all-destination-details",
    "get-destination-detail-by-extenstion-id",
    "get-voicemail-delivery-setup-by-id",
    "update-agent-voicemail"

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["voicemail-mapping"].id
  path_part   = each.value
}

##/api/voicemail-mapping/add-agent-voicemail

resource "aws_api_gateway_method" "add_agent_voicemail" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail-mapping_sub_resources["add-agent-voicemail"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_agent_voicemail_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail-mapping_sub_resources["add-agent-voicemail"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_agent_voicemail_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail-mapping_sub_resources["add-agent-voicemail"].id
  http_method             = aws_api_gateway_method.add_agent_voicemail_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_agent_voicemail_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail-mapping_sub_resources["add-agent-voicemail"].id
  http_method             = aws_api_gateway_method.add_agent_voicemail.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
##/api/voicemail-mapping/delete-agent-voicemail/{userSSOId}

resource "aws_api_gateway_resource" "delete_agent_voicemail" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.voicemail-mapping_sub_resources["delete-agent-voicemail"].id
  path_part   = "{userSSOId}"
}


resource "aws_api_gateway_method" "delete_agent_voicemail" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_agent_voicemail.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_agent_voicemail_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_agent_voicemail.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_agent_voicemail_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_agent_voicemail.id
  http_method             = aws_api_gateway_method.delete_agent_voicemail_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_agent_voicemail_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_agent_voicemail.id
  http_method             = aws_api_gateway_method.delete_agent_voicemail.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


##/api/voicemail-mapping/get-all-destination-details
resource "aws_api_gateway_method" "get_all_destination_details" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail-mapping_sub_resources["get-all-destination-details"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_all_destination_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail-mapping_sub_resources["get-all-destination-details"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_all_destination_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail-mapping_sub_resources["get-all-destination-details"].id
  http_method             = aws_api_gateway_method.get_all_destination_details_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_all_destination_detail_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail-mapping_sub_resources["get-all-destination-details"].id
  http_method             = aws_api_gateway_method.get_all_destination_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}
##/api/voicemail-mapping/get-destination-detail-by-extenstion-id/{extensionId}

resource "aws_api_gateway_resource" "get_destination_detail_by_extenstion_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.voicemail-mapping_sub_resources["get-destination-detail-by-extenstion-id"].id
  path_part   = "{extensionId}"
}


resource "aws_api_gateway_method" "get_destination_detail_by_extenstion_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_destination_detail_by_extenstion_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_destination_detail_by_extenstion_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_destination_detail_by_extenstion_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_destination_detail_by_extenstion_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_destination_detail_by_extenstion_id.id
  http_method             = aws_api_gateway_method.get_destination_detail_by_extenstion_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_destination_detail_by_extenstion_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_destination_detail_by_extenstion_id.id
  http_method             = aws_api_gateway_method.get_destination_detail_by_extenstion_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


##/api/voicemail-mapping/update-agent-voicemail


resource "aws_api_gateway_method" "update_agent_voicemail" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail-mapping_sub_resources["update-agent-voicemail"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_agent_voicemail_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.voicemail-mapping_sub_resources["update-agent-voicemail"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_agent_voicemail_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail-mapping_sub_resources["update-agent-voicemail"].id
  http_method             = aws_api_gateway_method.update_agent_voicemail_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_agent_voicemail_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.voicemail-mapping_sub_resources["update-agent-voicemail"].id
  http_method             = aws_api_gateway_method.update_agent_voicemail.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#reconnect

resource "aws_api_gateway_resource" "reconnect_mapping_sub_resources" {
  for_each = toset([
    "get-configurations",
    "get-configurations-by-id",
    "add-configuration",
    "update-configuration",
    "delete-configuration",

  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["reconnect"].id
  path_part   = each.value
}

##get
resource "aws_api_gateway_method" "get_configuraion_reconnect" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.reconnect_mapping_sub_resources["get-configurations"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_configuraion_reconnect_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.reconnect_mapping_sub_resources["get-configurations"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_configuraion_reconnect_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.reconnect_mapping_sub_resources["get-configurations"].id
  http_method             = aws_api_gateway_method.get_configuraion_reconnect_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_configuraion_reconnect_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.reconnect_mapping_sub_resources["get-configurations"].id
  http_method             = aws_api_gateway_method.get_configuraion_reconnect.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##get by id

resource "aws_api_gateway_resource" "get_configuraion_reconnect_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.reconnect_mapping_sub_resources["get-configurations-by-id"].id
  path_part   = "{csrSSO}"
}


resource "aws_api_gateway_method" "get_configuraion_reconnect_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_configuraion_reconnect_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_configuraion_reconnect_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_configuraion_reconnect_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_configuraion_reconnect_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_configuraion_reconnect_id.id
  http_method             = aws_api_gateway_method.get_configuraion_reconnect_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_configuraion_reconnect_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_configuraion_reconnect_id.id
  http_method             = aws_api_gateway_method.get_configuraion_reconnect_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "add_configuraion_reconnect" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.reconnect_mapping_sub_resources["add-configuration"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_configuraion_reconnect_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.reconnect_mapping_sub_resources["add-configuration"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_configuraion_reconnect_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.reconnect_mapping_sub_resources["add-configuration"].id
  http_method             = aws_api_gateway_method.add_configuraion_reconnect_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_configuraion_reconnect_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.reconnect_mapping_sub_resources["add-configuration"].id
  http_method             = aws_api_gateway_method.add_configuraion_reconnect.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#delete

resource "aws_api_gateway_resource" "delete_configuraion_reconnect" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.reconnect_mapping_sub_resources["delete-configuration"].id
  path_part   = "{csrSSO}"
}


resource "aws_api_gateway_method" "delete_configuraion_reconnect" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_configuraion_reconnect.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_configuraion_reconnect_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_configuraion_reconnect.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_configuraion_reconnect_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_configuraion_reconnect.id
  http_method             = aws_api_gateway_method.delete_configuraion_reconnect_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_configuraion_reconnect_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_configuraion_reconnect.id
  http_method             = aws_api_gateway_method.delete_configuraion_reconnect.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##update

resource "aws_api_gateway_method" "update_configuration_reconnect" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.reconnect_mapping_sub_resources["update-configuration"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_configuration_reconnect_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.reconnect_mapping_sub_resources["update-configuration"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_configuration_reconnect_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.reconnect_mapping_sub_resources["update-configuration"].id
  http_method             = aws_api_gateway_method.update_configuration_reconnect_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_configuration_reconnect_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.reconnect_mapping_sub_resources["update-configuration"].id
  http_method             = aws_api_gateway_method.update_configuration_reconnect.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}


#cloudwatch alarms
resource "aws_api_gateway_resource" "cloudwatch_alarm_mapping_sub_resources" {
  for_each = toset([
    "get-configurations",
    "get-configurations-by-id",
    "add-configuration",
    "update-configuration",
    "delete-configuration"
  ])
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.api_sub_resources["cloudwatch-alarm"].id
  path_part   = each.value
}

##get
resource "aws_api_gateway_method" "get_configuraion_cloudwatch_alarm" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["get-configurations"].id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_configuraion_cloudwatch_alarm_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["get-configurations"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_configuraion_cloudwatch_alarm_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["get-configurations"].id
  http_method             = aws_api_gateway_method.get_configuraion_cloudwatch_alarm_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_configuraion_cloudwatch_alarm_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["get-configurations"].id
  http_method             = aws_api_gateway_method.get_configuraion_cloudwatch_alarm.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##get by id

resource "aws_api_gateway_resource" "get_configuraion_cloudwatch_alarm_id" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["get-configurations-by-id"].id
  path_part   = "{alarmId}"
}


resource "aws_api_gateway_method" "get_configuraion_cloudwatch_alarm_id" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_configuraion_cloudwatch_alarm_id.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "get_configuraion_cloudwatch_alarm_id_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.get_configuraion_cloudwatch_alarm_id.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "get_configuraion_cloudwatch_alarm_id_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_configuraion_cloudwatch_alarm_id.id
  http_method             = aws_api_gateway_method.get_configuraion_cloudwatch_alarm_id_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "get_configuraion_cloudwatch_alarm_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.get_configuraion_cloudwatch_alarm_id.id
  http_method             = aws_api_gateway_method.get_configuraion_cloudwatch_alarm_id.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "add_configuraion_cloudwatch_alarm" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["add-configuration"].id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "add_configuraion_cloudwatch_alarm_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["add-configuration"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "add_configuraion_cloudwatch_alarm_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["add-configuration"].id
  http_method             = aws_api_gateway_method.add_configuraion_cloudwatch_alarm_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "add_configuraion_cloudwatch_alarm_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["add-configuration"].id
  http_method             = aws_api_gateway_method.add_configuraion_cloudwatch_alarm.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

#delete

resource "aws_api_gateway_resource" "delete_configuraion_cloudwatch_alarm" {
  rest_api_id = aws_api_gateway_rest_api.command_center.id
  parent_id   = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["delete-configuration"].id
  path_part   = "{alarmId}"
}


resource "aws_api_gateway_method" "delete_configuraion_cloudwatch_alarm" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_configuraion_cloudwatch_alarm.id
  http_method          = "DELETE"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "delete_configuraion_cloudwatch_alarm_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.delete_configuraion_cloudwatch_alarm.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "delete_configuraion_cloudwatch_alarm_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_configuraion_cloudwatch_alarm.id
  http_method             = aws_api_gateway_method.delete_configuraion_cloudwatch_alarm_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "delete_configuraion_cloudwatch_alarm_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.delete_configuraion_cloudwatch_alarm.id
  http_method             = aws_api_gateway_method.delete_configuraion_cloudwatch_alarm.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

##update

resource "aws_api_gateway_method" "update_configuration_cloudwatch_alarm" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["update-configuration"].id
  http_method          = "PUT"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_method" "update_configuration_cloudwatch_alarm_options" {
  rest_api_id          = aws_api_gateway_rest_api.command_center.id
  resource_id          = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["update-configuration"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.command_center.id
}

resource "aws_api_gateway_integration" "update_configuration_cloudwatch_alarm_mock" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["update-configuration"].id
  http_method             = aws_api_gateway_method.update_configuration_cloudwatch_alarm_options.http_method
  type                    = "MOCK"
  integration_http_method = "POST"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  lifecycle {
    ignore_changes = [
      integration_http_method
    ]
  }
}

resource "aws_api_gateway_integration" "update_configuration_cloudwatch_alarm_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.command_center.id
  resource_id             = aws_api_gateway_resource.cloudwatch_alarm_mapping_sub_resources["update-configuration"].id
  http_method             = aws_api_gateway_method.update_configuration_cloudwatch_alarm.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.command_center_lambda.invoke_arn
  integration_http_method = "POST"
}

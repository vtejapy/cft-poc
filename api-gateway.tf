###pi

```
#amazon connect api core functionality

resource "aws_api_gateway_rest_api" "connect_core_api" {
  name        = "connect-core-private-api-${var.client}-${var.region}-${var.environment}"
  description = "AWS Connect API"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.contact_center_core_api.id]
  }

  tags = merge(local.common_tags, {
    Name = "connect-core-private-api-${var.client}-${var.region}-${var.environment}"
  })
  lifecycle {
    create_before_destroy = true
  }

}


# API sub-resources
resource "aws_api_gateway_resource" "connect_core_private_api_gen_sub_resources" {
  for_each = toset([
    "agent-desktop-jwt-authorizer",
    "api"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_rest_api.connect_core_api.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_request_validator" "connect_core_api" {
  name                        = "connect-core-private-api"
  rest_api_id                 = aws_api_gateway_rest_api.connect_core_api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "jwt_auth" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.connect_core_private_api_gen_sub_resources["agent-desktop-jwt-authorizer"].id
  http_method          = "ANY"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.connect_core_private_api_gen_sub_resources["agent-desktop-jwt-authorizer"].id
  http_method             = aws_api_gateway_method.jwt_auth.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

# API sub-resources
resource "aws_api_gateway_resource" "connect_core_private_api_sub_resources" {
  for_each = toset([
    "calllog",
    "ctr",
    "destination-extension",
    "fraudnumber",
    "postcallsurvey",
    "prompts-message",
    "queue-experience",
    "sync",
    "voicemail",
    "ivr-config",
    "vm-personal-msg",
    "reconnect",
    "cloudwatch-alarm",
    "insurance-core"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_gen_sub_resources["api"].id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "api_calllog" {
  for_each = toset([
    "getcalllogs"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["calllog"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "calllog_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_calllog["getcalllogs"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "callog_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_calllog["getcalllogs"].id
  http_method             = aws_api_gateway_method.calllog_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#ctr

resource "aws_api_gateway_resource" "api_ctr" {
  for_each = toset([
    "putctr"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["ctr"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "putctr_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_ctr["putctr"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "ctr_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_ctr["putctr"].id
  http_method             = aws_api_gateway_method.putctr_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#destinatino-extension

resource "aws_api_gateway_resource" "api_destination" {
  for_each = toset([
    "get-destination-detail-by-extenstion-id"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["destination-extension"].id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "extensionid" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_destination["get-destination-detail-by-extenstion-id"].id
  path_part   = "{extensionId}"
}
resource "aws_api_gateway_method" "extension_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.extensionid.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "dest_extension_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.extensionid.id
  http_method             = aws_api_gateway_method.extension_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#fraudnumber

resource "aws_api_gateway_resource" "api_fraudnumber" {
  for_each = toset([
    "get_number_by_id"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["fraudnumber"].id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "fraud_number" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_fraudnumber["get_number_by_id"].id
  path_part   = "{fraud_number}"
}


resource "aws_api_gateway_method" "get_fraud_number_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.fraud_number.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "fraud_number_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.fraud_number.id
  http_method             = aws_api_gateway_method.get_fraud_number_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}
resource "aws_api_gateway_method" "fraud_number_options_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.fraud_number.id
  http_method          = "OPTIONS"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "fraud_number_options_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.fraud_number.id
  http_method             = aws_api_gateway_method.fraud_number_options_method.http_method
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


#postcallsurvey
resource "aws_api_gateway_resource" "api_postcall" {
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
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["postcallsurvey"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "postcall_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_postcall["add-result"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_postcall["add-result"].id
  http_method             = aws_api_gateway_method.postcall_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_method" "postcall_add_survey_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_postcall["add-survey"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_add_survey_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_postcall["add-survey"].id
  http_method             = aws_api_gateway_method.postcall_add_survey_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_resource" "delete_survey_id" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_postcall["delete-survey"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcall_delete_survey_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.delete_survey_id.id
  http_method          = "DELETE"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "post_call_delete_survey_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.delete_survey_id.id
  http_method             = aws_api_gateway_method.postcall_delete_survey_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_resource" "postcall_getresult_surveyid" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_postcall["get-result"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcall_getresult_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.postcall_getresult_surveyid.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_getreuslt_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.postcall_getresult_surveyid.id
  http_method             = aws_api_gateway_method.postcall_getresult_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_method" "postcall_get_survey_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_postcall["get-survey"].id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_get_surveyy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_postcall["get-survey"].id
  http_method             = aws_api_gateway_method.postcall_get_survey_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_resource" "postcall_survey_id" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_postcall["get-survey-by-id"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcall_surveyid_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.postcall_survey_id.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_surveyid_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.postcall_survey_id.id
  http_method             = aws_api_gateway_method.postcall_surveyid_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_resource" "postcall_get_survey_details" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_postcall["get-survey-details"].id
  path_part   = "{survey_id}"
}


resource "aws_api_gateway_method" "postcall_surveydetails_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.postcall_get_survey_details.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_surveydetails_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.postcall_get_survey_details.id
  http_method             = aws_api_gateway_method.postcall_surveydetails_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_method" "postcall_update_survey_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_postcall["update-survey"].id
  http_method          = "PUT"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "postcall_update_survey_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_postcall["update-survey"].id
  http_method             = aws_api_gateway_method.postcall_update_survey_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#prompts-message

resource "aws_api_gateway_resource" "api_promptmessage" {
  for_each = toset([
    "get-message"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["prompts-message"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "promptmsg_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_promptmessage["get-message"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "promptmsg_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_promptmessage["get-message"].id
  http_method             = aws_api_gateway_method.promptmsg_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#queue-experience

resource "aws_api_gateway_resource" "api_queue_experience" {
  for_each = toset([
    "get-details"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["queue-experience"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "queueexp_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_queue_experience["get-details"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "quueuexp_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_queue_experience["get-details"].id
  http_method             = aws_api_gateway_method.queueexp_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}
#sync

resource "aws_api_gateway_method" "sync_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.connect_core_private_api_sub_resources["sync"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "sync_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.connect_core_private_api_sub_resources["sync"].id
  http_method             = aws_api_gateway_method.sync_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#voicemail
resource "aws_api_gateway_resource" "api_voicemail" {
  for_each = toset([
    "get-voicemail-delivery-setups-by-aws-id"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["voicemail"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "get_voicemail_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_voicemail["get-voicemail-delivery-setups-by-aws-id"].id
  http_method          = "POST"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "voicemail_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_voicemail["get-voicemail-delivery-setups-by-aws-id"].id
  http_method             = aws_api_gateway_method.get_voicemail_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#ivr-config
resource "aws_api_gateway_resource" "api_ivr_config" {
  for_each = toset([
    "get-ivr-config"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["ivr-config"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "get_ivr_config_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.api_ivr_config["get-ivr-config"].id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "get_ivr_config_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.api_ivr_config["get-ivr-config"].id
  http_method             = aws_api_gateway_method.get_ivr_config_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#vm-personal-msg
resource "aws_api_gateway_resource" "api_vm_personal_msg" {
  for_each = toset([
    "get-vm-personal-msg-by-id"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["vm-personal-msg"].id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "get_vm_personal_msgby_id" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_vm_personal_msg["get-vm-personal-msg-by-id"].id
  path_part   = "{csrSSO}"
}
resource "aws_api_gateway_method" "get_vm_personal_msgby_id_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.get_vm_personal_msgby_id.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "get_vm_personal_msgby_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.get_vm_personal_msgby_id.id
  http_method             = aws_api_gateway_method.get_vm_personal_msgby_id_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}
#reconnect
#reconnect/get-csr-by-id
resource "aws_api_gateway_resource" "api_reconnect" {
  for_each = toset([
    "get-csr-by-id"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["reconnect"].id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "get_reconnect_by_id" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_reconnect["get-csr-by-id"].id
  path_part   = "{csrSSO}"
}
resource "aws_api_gateway_method" "get_reconnect_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.get_reconnect_by_id.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "get_reconnect_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.get_reconnect_by_id.id
  http_method             = aws_api_gateway_method.get_reconnect_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}

#cloudwatch Alarm
#cloudwatch-alarm/get-notification-details/{alarmName}
resource "aws_api_gateway_resource" "api_cloudwatch" {
  for_each = toset([
    "get-notification-details"
  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["cloudwatch-alarm"].id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "get_cloudwatch_alarm" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.api_cloudwatch["get-notification-details"].id
  path_part   = "{alarmName}"
}


resource "aws_api_gateway_method" "get_cloudwatch_alarm_method" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.get_cloudwatch_alarm.id
  http_method          = "GET"
  authorization        = "AWS_IAM"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "get_cloudwatch_alarm_integration" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.get_cloudwatch_alarm.id
  http_method             = aws_api_gateway_method.get_cloudwatch_alarm_method.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
}


resource "aws_api_gateway_deployment" "connect_core_private_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id

  triggers = {
    #redeployment = sha1(jsonencode(var.private_1_api_file))
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.connect_core_api.body,
      values(aws_api_gateway_resource.api_ivr_config)[*].id,
      aws_api_gateway_method.get_ivr_config_method.id,
      aws_api_gateway_integration.get_ivr_config_integration,
      values(aws_api_gateway_resource.api_vm_personal_msg)[*].id,
      aws_api_gateway_resource.get_vm_personal_msgby_id.id,
      aws_api_gateway_method.get_vm_personal_msgby_id_method.id,
      aws_api_gateway_integration.get_vm_personal_msgby_id_integration.id,
      values(aws_api_gateway_resource.api_reconnect)[*].id,
      values(aws_api_gateway_resource.api_cloudwatch)[*].id
    ]))
  }
  depends_on = [aws_api_gateway_rest_api_policy.private_api]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "conect_core_private_api_stage" {
  deployment_id = aws_api_gateway_deployment.connect_core_private_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  stage_name    = var.environment
  depends_on    = [aws_api_gateway_deployment.connect_core_private_api_deployment]
  tags = merge(local.common_tags, {
    Name = "connect-core-private-api-stage-${var.client}-${var.region}-${var.environment}"
  })
  lifecycle {
    ignore_changes = [
      cache_cluster_enabled
    ]
  }
}


#insurance-core

resource "aws_api_gateway_resource" "insurance_core_sub_resources" {
  for_each = toset([
    "getEvents",
    "getPolicyDetails",
    "getPremiumDetails",
    "identifyByPhoneNumber",
    "identifyProducer",
    "identifyProducerByPhoneNumber"

  ])
  rest_api_id = aws_api_gateway_rest_api.connect_core_api.id
  parent_id   = aws_api_gateway_resource.connect_core_private_api_sub_resources["insurance-core"].id
  path_part   = each.value
}

resource "aws_api_gateway_method" "getevents" {
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  resource_id   = aws_api_gateway_resource.insurance_core_sub_resources["getEvents"].id
  http_method   = "POST"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "getevents_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["getEvents"].id
  http_method             = aws_api_gateway_method.getevents.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  integration_http_method = "POST"
}
resource "aws_api_gateway_method" "getevents_options" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.insurance_core_sub_resources["getEvents"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "getevents_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["getEvents"].id
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


#getPolicyDetails

resource "aws_api_gateway_method" "get_policy_details" {
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  resource_id   = aws_api_gateway_resource.insurance_core_sub_resources["getPolicyDetails"].id
  http_method   = "GET"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
  request_parameters = {
    "method.request.querystring.policy_or_claim_number" = true
    "method.request.querystring.role"                   = true
  }

}

resource "aws_api_gateway_integration" "get_policy_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["getPolicyDetails"].id
  http_method             = aws_api_gateway_method.get_policy_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  integration_http_method = "POST"
  request_parameters = {
    "integration.request.querystring.policy_or_claim_number" = "method.request.querystring.policy_or_claim_number"
    "integration.request.querystring.role"                   = "method.request.querystring.role"
  }
  depends_on = [aws_api_gateway_method.get_policy_details]
}
resource "aws_api_gateway_method" "get_policy_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.insurance_core_sub_resources["getPolicyDetails"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "get_policy_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["getPolicyDetails"].id
  http_method             = aws_api_gateway_method.get_policy_details_options.http_method
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

#getPremiumDetails

resource "aws_api_gateway_method" "get_premium_details" {
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  resource_id   = aws_api_gateway_resource.insurance_core_sub_resources["getPremiumDetails"].id
  http_method   = "GET"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
  request_parameters = {
    "method.request.querystring.policy_number" = true
  }
}

resource "aws_api_gateway_integration" "get_premium_details_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["getPremiumDetails"].id
  http_method             = aws_api_gateway_method.get_premium_details.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  integration_http_method = "POST"
  request_parameters = {
    "integration.request.querystring.policy_number" = "method.request.querystring.policy_number"
  }
  depends_on = [aws_api_gateway_method.get_premium_details]
}
resource "aws_api_gateway_method" "get_premium_details_options" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.insurance_core_sub_resources["getPremiumDetails"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "get_premium_details_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["getPremiumDetails"].id
  http_method             = aws_api_gateway_method.get_premium_details_options.http_method
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

#identifyByPhoneNumber

resource "aws_api_gateway_method" "identify_by_phone_number" {
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  resource_id   = aws_api_gateway_resource.insurance_core_sub_resources["identifyByPhoneNumber"].id
  http_method   = "GET"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
  request_parameters = {
    "method.request.querystring.phone_number" = true
    "method.request.querystring.role"         = false
  }
}

resource "aws_api_gateway_integration" "identify_by_phone_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["identifyByPhoneNumber"].id
  http_method             = aws_api_gateway_method.identify_by_phone_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  integration_http_method = "POST"
  request_parameters = {
    "integration.request.querystring.phone_number" = "method.request.querystring.phone_number"
    "integration.request.querystring.role"         = "method.request.querystring.role"
  }
  depends_on = [aws_api_gateway_method.identify_by_phone_number]
}
resource "aws_api_gateway_method" "identify_by_phone_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.insurance_core_sub_resources["identifyByPhoneNumber"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "identify_by_phone_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["identifyByPhoneNumber"].id
  http_method             = aws_api_gateway_method.identify_by_phone_number_options.http_method
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

#identifyProducer

resource "aws_api_gateway_method" "identify_producer" {
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  resource_id   = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducer"].id
  http_method   = "GET"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
  request_parameters = {
    "method.request.querystring.producer_id" = true
  }
}

resource "aws_api_gateway_integration" "identify_producer_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducer"].id
  http_method             = aws_api_gateway_method.identify_producer.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  integration_http_method = "POST"
  request_parameters = {
    "integration.request.querystring.producer_id" = "method.request.querystring.producer_id"
  }
  depends_on = [aws_api_gateway_method.identify_producer]
}
resource "aws_api_gateway_method" "identify_producer_options" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducer"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "identify_producer_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducer"].id
  http_method             = aws_api_gateway_method.identify_producer_options.http_method
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

#identify_producer_by_phone_number

resource "aws_api_gateway_method" "identify_producer_by_phone_number" {
  rest_api_id   = aws_api_gateway_rest_api.connect_core_api.id
  resource_id   = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducerByPhoneNumber"].id
  http_method   = "POST"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "identify_producer_by_phone_number_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducerByPhoneNumber"].id
  http_method             = aws_api_gateway_method.identify_producer_by_phone_number.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact_center_core_api_lambda.invoke_arn
  integration_http_method = "POST"
}
resource "aws_api_gateway_method" "identify_producer_by_phone_number_options" {
  rest_api_id          = aws_api_gateway_rest_api.connect_core_api.id
  resource_id          = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducerByPhoneNumber"].id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.connect_core_api.id
}

resource "aws_api_gateway_integration" "identify_producer_by_phone_number_mock" {
  rest_api_id             = aws_api_gateway_rest_api.connect_core_api.id
  resource_id             = aws_api_gateway_resource.insurance_core_sub_resources["identifyProducerByPhoneNumber"].id
  http_method             = aws_api_gateway_method.identify_producer_by_phone_number_options.http_method
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
```
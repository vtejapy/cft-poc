#event

```
# outbound-contact-precheck-utility

resource "aws_cloudwatch_event_rule" "outbound_contact_event_rule" {
  name                = "outbound-contact-event-rule-${var.client}-${var.region}-${var.environment}"
  description         = "rule to trigger 911 disconnect Lambda function"
  schedule_expression = "cron(0 */3 * * ? *)"
  tags = merge(local.common_tags, {
    name = "outbound-contact-event-rule-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_cloudwatch_event_target" "outbound_contact_precheck_lambda_target" {
  rule      = aws_cloudwatch_event_rule.outbound_contact_event_rule.name
  target_id = "outbound-contact-event-trigger-${var.client}-${var.region}-${var.environment}"
  arn       = aws_lambda_function.outbound_contact_precheck_utility_lambda.arn
}

resource "aws_lambda_permission" "outbound_contact_precheck_eventbridge_permission" {
  statement_id  = "outboundContactTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.outbound_contact_precheck_utility_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.outbound_contact_event_rule.arn
}
```
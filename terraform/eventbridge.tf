
// CRON
resource "aws_cloudwatch_event_rule" "cron" {
  name = "${local.prefix}check-item-no"
  description = "Check item.no every 5 minutes"
  schedule_expression = "cron(*/5 * * * ? *)"
}

// CRON skal kjøre lambda
resource "aws_cloudwatch_event_target" "invoke-lambda" {
  arn  = aws_lambda_function.check-website.arn
  rule = aws_cloudwatch_event_rule.cron.name

  // Prøv på nytt to ganger
  retry_policy {
    maximum_retry_attempts = 2
    maximum_event_age_in_seconds = 120
  }

  input = jsonencode({
    url: local.url
    searchFor: local.searchFor
  })
}


// EventBridge må ha lov til å kjøre lambda
resource "aws_lambda_permission" "invoice-export-check" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check-website.function_name
  principal     = "events.amazonaws.com"

  // Kun cron-regelen har lov til å kjøre lambda
  source_arn = aws_cloudwatch_event_rule.cron.arn
}
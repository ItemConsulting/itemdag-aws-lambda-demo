
resource "aws_sns_topic" "failures" {
  name = "${local.prefix}failures"

  tags = local.tags
}

resource "aws_lambda_function_event_invoke_config" "publish-sns" {
  function_name = aws_lambda_function.check-website.function_name

  destination_config {
    on_failure {
      destination = aws_sns_topic.failures.arn
    }
  }
}

// Slack-lambda lytter etter feilmeldinger
resource "aws_sns_topic_subscription" "failures" {
  endpoint  = aws_lambda_function.notify-slack.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.failures.arn
}

resource "aws_lambda_permission" "invoice-lambda-from-sns" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notify-slack.function_name
  principal     = "sns.amazonaws.com"

  // Kun failure-topic har lov å kjøre lambdaen
  source_arn = aws_sns_topic.failures.arn
}

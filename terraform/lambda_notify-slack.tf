
// Lambda for å publisere til Slack
resource "aws_lambda_function" "notify-slack" {
  function_name = "${local.prefix}notify-slack"

  s3_bucket = local.bucket
  s3_key = "notify-slack/notify-slack-1.0.0.jar"

  // Funksjon som skal kalles
  handler = "Main::handle"
  // Kjør JVM
  runtime = "java11"

  // Kjøretid og kapasitet
  timeout = 120
  memory_size = 256

  role          = aws_iam_role.notify-slack.arn
}


resource "aws_iam_role" "notify-slack" {
  // Hvem kan bruke denne rollen
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
  tags = local.tags
}

// Kan skrive til CloudWatch logs
resource "aws_iam_role_policy" "notify-slack-write-logs" {
  name = "${local.prefix}write-logs"
  role = aws_iam_role.notify-slack.id
  policy = data.aws_iam_policy_document.write-logs.json
}

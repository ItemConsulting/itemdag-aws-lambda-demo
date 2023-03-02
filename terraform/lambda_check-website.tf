
// Lambda for å sjekke nettside
resource "aws_lambda_function" "check-website" {
  function_name = "${local.prefix}check-website"

  s3_bucket = local.bucket
  s3_key = "check-website/check-website-1.0.1.jar"

  // Funksjon som skal kalles
  handler = "Main::handle"
  // Kjør JVM
  runtime = "java11"

  // Kjøretid og kapasitet
  timeout = 120
  memory_size = 256

  // hva har funksjonen lov til å gjøre
  role          = aws_iam_role.check-website.arn
  tags = local.tags
}


resource "aws_iam_role" "check-website" {
  // Hvem kan bruke denne rollen
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
  tags = local.tags
}

// Kan skrive til CloudWatch logs
resource "aws_iam_role_policy" "check-website-write-logs" {
  name = "${local.prefix}write-logs"
  role = aws_iam_role.check-website.id
  policy = data.aws_iam_policy_document.write-logs.json
}

// Koble sammen rolle med tillatelser (policy)
resource "aws_iam_role_policy" "attach-sns" {
  name = "${local.prefix}publish-sns"
  role = aws_iam_role.check-website.id
  policy = data.aws_iam_policy_document.publish-sns.json
}

// Lambda har lov til å publisere til SNS topic
data "aws_iam_policy_document" "publish-sns" {
  version = "2012-10-17"
  statement {
    sid = "PublishToSNS"
    actions = [
      "sns:Publish" // publisere til SNS
    ]
    effect = "Allow"
    resources = [
      aws_sns_topic.failures.arn // kun til dette SNS topic
    ]
  }
}

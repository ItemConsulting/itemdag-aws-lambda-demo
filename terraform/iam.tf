

// Lambda har lov til å bruke en rolle
data "aws_iam_policy_document" "assume-role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "write-logs" {
  version = "2012-10-17"
  statement {
    sid = "AllowLogging"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    ]
  }
}

data "aws_iam_policy_document" "plan_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.plan_subs
    }
  }
}

resource "aws_iam_role" "plan" {
  name               = "${var.repo}-plan"
  assume_role_policy = data.aws_iam_policy_document.plan_assume.json
  description        = "Read-only plan role for ${var.repo}. Assumed by PR plan jobs."
}

resource "aws_iam_role_policy_attachment" "plan_readonly" {
  role       = aws_iam_role.plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "plan_lock" {
  statement {
    sid    = "TerraformStateLock"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.state_lock_table}"]
  }
}

resource "aws_iam_policy" "plan_lock" {
  name   = "${var.repo}-plan-lock"
  policy = data.aws_iam_policy_document.plan_lock.json
}

resource "aws_iam_role_policy_attachment" "plan_lock" {
  role       = aws_iam_role.plan.name
  policy_arn = aws_iam_policy.plan_lock.arn
}
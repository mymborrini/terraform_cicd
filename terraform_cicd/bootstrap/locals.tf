locals {
  oidc_url = "https://token.actions.githubusercontent.com"

  # The OIDC "sub" claim binds a role to one repo AND one environment. This is
  # the whole security model: a role only trusts tokens minted for a specific
  # environment, so a PR (or a workflow in another repo) cannot assume it.
  deploy_subs = [
    "repo:${var.github_org}/${var.repo}:environment:sandbox",
    "repo:${var.github_org}/${var.repo}:environment:prod",
  ]
  plan_subs = [
    "repo:${var.github_org}/${var.repo}:environment:sandbox-plan",
    "repo:${var.github_org}/${var.repo}:environment:prod-plan",
  ]
}

locals {
  envs = {
    sandbox = {
      name             = "sandbox"
      arn              = aws_iam_role.deploy.arn
      gate             = "main"
      require_reviewer = false
    }
    sandbox_plan = {
      name             = "sandbox-plan"
      arn              = aws_iam_role.plan.arn
      gate             = "none"
      require_reviewer = false
    }
    prod = {
      name             = "prod"
      arn              = aws_iam_role.deploy.arn
      gate             = "tag"
      require_reviewer = true
    }
    prod_plan = {
      name             = "prod-plan"
      arn              = aws_iam_role.plan.arn
      gate             = "none"
      require_reviewer = false
    }
  }
}
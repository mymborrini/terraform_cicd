data "github_user" "reviewers" {
  for_each = toset(var.reviewers)
  username = each.value
}

resource "github_repository_environment" "this" {
  for_each    = local.envs
  repository  = var.repo
  environment = each.value.name

  # Plan envs have no branch restriction so PR refs can use them.
  dynamic "deployment_branch_policy" {
    for_each = each.value.gate != "none" ? [1] : []
    content {
      protected_branches     = false
      custom_branch_policies = true
    }
  }

  # Required reviewer on the prod apply env. At least one listed user approves.
  dynamic "reviewers" {
    for_each = each.value.require_reviewer && length(var.reviewers) > 0 ? [1] : []
    content {
      users = [for u in data.github_user.reviewers : u.id]
    }
  }
}


# main-only branch policy for the main and tag gated envs.
resource "github_repository_environment_deployment_policy" "main_branch" {
  for_each       = { for k, v in local.envs : k => v if v.gate != "none" }
  repository     = var.repo
  environment    = github_repository_environment.this[each.key].environment
  branch_pattern = "main"
}


resource "github_repository_environment_deployment_policy" "tag_prod" {
  for_each    = { for k, v in local.envs : k => v if v.gate == "tag" }
  repository  = var.repo
  environment = github_repository_environment.this[each.key].environment
  tag_pattern = "v*.*.*"
}

resource "github_actions_environment_secret" "aws_role_arn" {
  for_each    = local.envs
  repository  = var.repo
  environment = github_repository_environment.this[each.key].environment
  secret_name = "AWS_ROLE_ARN"
  value       = each.value.arn
}
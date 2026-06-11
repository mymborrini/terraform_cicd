output "oidc_provider_arn" {
  description = "OIDC provider ARN. Record in your account inventory."
  value       = aws_iam_openid_connect_provider.github.arn
}

output "deploy_role_arn" {
  description = "Apply role ARN. Written to AWS_ROLE_ARN on the sandbox and prod environments."
  value       = aws_iam_role.deploy.arn
}

output "plan_role_arn" {
  description = "Read-only plan role ARN. Written to AWS_ROLE_ARN on the sandbox-plan and prod-plan environments."
  value       = aws_iam_role.plan.arn
}
# Bootstrap

Run this once per AWS account, by hand, with admin credentials. It creates the GitHub OIDC provider, the deploy and plan roles, and the four GitHub Environments with their AWS_ROLE_ARN secrets. After this, the pipeline runs on its own with no long-lived AWS keys anywhere.

## What it creates

- OIDC provider for token.actions.githubusercontent.com (one per account).
- *<repo>-deploy* role, AdministratorAccess. Trusted only by the sandbox and prod GitHub Environments.
- *<repo>-plan* role,  ReadOnlyAccess plus state-lock writes. Trusted by the sandbox-plan and prod-plan environments. PR plan jobs use this, so a malicious PR cannot apply or destroy anything.
- Four GitHub Environments with AWS_ROLE_ARN set
  - *sandbox* apply, main only, no reviewer.
  - *sandbox-plan* plan, any ref.
  - *prod* apply, `v*.*.*` tag plus one required reviewer.
  - *prod-plan* plan, any ref.

## Prerequisites

1. Admin access to the target AWS account (SSO or keys). In this case I use localstack... so this point is skipped
2. A GitHub token with repo scope, exported so the github provider can use it:

    gh auth login --scopes repo
    export GITHUB_TOKEN=$(gh auth token)

3. State backend. The repo defaults to local state, so the bootstrap stack writes to ./state/bootstrap.tfstate with no setup. If you've switched the stacks to S3, create the bucket and lock table first:

    make bootstrap-state-backend

## Run it

    make bootstrap-init
    make bootstrap-plan
    make bootstrap-apply



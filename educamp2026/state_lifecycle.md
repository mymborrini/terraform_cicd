# State lifecycle Management


tfstate acts a source of truth. tfstate container sensitive information the state must be shared and encrypted.

To inspect terraform state file

 - terraform show
 - terraform state list

 tfstate.backup is the thing that are overriden last. So you can always make a different

 By default terraform use tfstate backend called local

In team you need to use a remote state like s3
DEPENDING ON THE BACKEND it allows you to do locking. 

Backends are built in so there is no need to install provider.

You can go with HCP but OpenTofu is an interesting opensource equivalent

The variable can be placed as sensitive so they will treat different when the state is printed in the plan for example. But this is all is done.Ti naabger a secret there is also another concept *ephemeral values*. They are not saved in the state. This is useful because it generates a password and automatically stores into vault. 

Expression derived by sensitive value becames sensitive too. Only if you ask specifically for the token 

    terraform output super-secret-value

The super-secret-value will be shown.

## State locking

Avoid two user to work on the same tfstate together

## Lifecycle rule

the lifecycle allows you to manage the life cycle of your resource

- create_before_destroy allows you in case of replacement to create the new resource before to destroy the old one
- prevent_destroy pretty self explenatory, avoid a resource to be destroyed

## Drift

You create a terraform infrastracture and something happens outside terraform. It creates a drift in the state. 
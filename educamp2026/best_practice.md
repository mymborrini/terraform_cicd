# Best Practice

## Workspaces

It's better to use folder separation. Workspaces are thought for ephemeral testing NO LONG LIFE environemnt

## Validation

You can do validation on variables like this for example

```hcl

validation {
 condition = length(var.resource_tags["environment"]) <= 8 && length(regexall([^a-zA-Z0-9-", var.resource_tags["environment"])) == 0
 error_message = "The environment tag must be no more than 8 
characters, and only contain letters, numbers, and hyphens."
 }
}
```

## AI Workflow

You can use terrafrom with AI workflow


## Importing Exisint Infrastracture


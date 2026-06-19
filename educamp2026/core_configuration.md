# Core Configuration Concept

Terraform install providers from the terraform registry by default

    https://regisgtry.terraform.io

resource <resource-type> <resource-name> {}

<resource-type>.<resource-name> is the way on how to refer your resources through terraform

When you refer a variable the variable is created in a namespace called `var` so when you have to make a reference to tht variable you have to type something like:

        var.<variable-name>

After doing *terraform apply* I can do a *terraform output* to just check what interested me

Like variable locals are stored in a namespace called *local*. Typically you use local when you need to concatenate stuff

```hcl
locals {
    common_name ="${var.something}-hello"
}
```

- proximus: 
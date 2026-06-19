# Iteration and conditional logic

- count
- for_each

count is useful when you want a set a similar resource, because it only has *count.index* as property

for_each is useful when you define a variable which is a list(object) and you can configure the same resources based on a different variable base

    for_each = toset(var.<something>)

*toset* method is important because it ensures that there are no duplicates and that every item in the list is of the same type

Instead of useing *fileset* it's better to separate infrastracture and data, so in this case create a new repository with the data, clone it and push it using terraform.


## Data sources

data sources are good when you have variables that change from region, environment

```hcl
data "aws_ami" "amazon2023" {
 owners = ["amazon"]
 most_recent = true # This is useful so if filter returns a list it will take autoamtically
 # the most recent one
 
 filter {
  
 }

}
```

For example this will return the most recent image of the amazon2023, it can vary from region to region

## Iteration in outputs...

Is somehting like this

```hcl
output "ec2_instance_public_ips" {
    description = "Public IP addresses of EC2 instances"
    value       = {for name,instance in module.ec2_instances : name => instance.public_ip}
}

output "ec2_ssh_connections" {
    description = "SSH connection for EC2 instances"
    value = {for name,instance in module.ec2_instances : name => "ssh -i student5 ec2-user@ec2-${instance.public_ip}.eu-south-2.compute.amazonaws.com"}
}
```


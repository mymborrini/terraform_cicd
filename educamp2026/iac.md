# Infrastracture as a code

- Dependency Graph

## Architecture

User -> .tf files ->  Terraform core (use providers) -> create State file -> Cloud service 
Providers to external API

## HCL

Hashicrp language

## Notes

- Implicit dependencies when referring the name
- optional method takes two parameter, the first one is the type and the second one is the default so for example

    index_document = optional(string, "index.html")
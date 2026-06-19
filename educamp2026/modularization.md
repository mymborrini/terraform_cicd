# Modularization

 .terraform.lock.hcl file contiene tutte le versioni esatte dei moduli e dei provider che usi. Come il package-lock.json

 When you specify a module, to know what to insert into it go to the documentation, like you always do with the providers


 WIth terraform output we can use it, to evoke some command like the following:

 aws s3 cp www/ s3://$(terraform output -raw bucket_name)/ --recursive
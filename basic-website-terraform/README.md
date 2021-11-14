## Summary
Basic infrastructure to stand up a test static website for use with my selenium-with-tor demo

## DON'T delete the terraform.tfstate file generated in this directory
This is how Terraform keeps track of resources. In a robust environment, you'd ALWAYS set a remote backend for this file. For this demo (and simplicity sake), I'm using the default local setting
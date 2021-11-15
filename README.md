### Meant to serve as a learning aid for my Medium article on [selenium-with-tor]()

### Will add independent README instructions in the future. For now, please refer to the article (use incognito/private mode if you get a paywall)

## DON'T delete the terraform.tfstate file generated in the basic-website-terraform directory
This is how Terraform keeps track of resources. In a robust environment, you'd ALWAYS set a remote backend for this file. For this demo (and simplicity sake), I'm using the default local setting
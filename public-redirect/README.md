
```hcl-terraform
provider "aws" {
  profile = "app-${terraform.workspace}"
  region  = "us-east-1"
  alias   = "edge"
}

module "redirect" {
  
  providers = {
    aws = "aws.edge"
  }
}

```
## BLOCKED
https://github.com/terraform-providers/terraform-provider-aws/issues/4757

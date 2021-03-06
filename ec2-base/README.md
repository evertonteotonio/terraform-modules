# EC2
Auto-scalling cluster of EC2

## Features
- Auto-scaling across defined subnets
- CloudWatch logging enabled
- CloudWatch agent for collecting additional metrics
- Inspector agent for allowing running of security assessments in Amazon Inspector
- SSM Agent for allowing shell access from Session AWS Systems Manager

## Setup

### Module
```hcl-terraform
module "ec2-base" {
  source            = "./modules/ec2-base"
  name              = "${local.name}-usecase"
  vpc_id            = "${module.vpc.id}"
  subnet_ids        = "${module.vpc.private_subnet_ids}"
  image_id          = "${local.image_id}"
  user_data         = templatefile("${path.module}/userdata.sh", {
    REGION          = "${local.region}"
  })
}
```

### Add custom policy
```hcl-terraform
resource "aws_iam_policy" "main-usecase" {
  name        = "${var.name}-usecase-policy"
  path        = "/"
  description = "${var.name}-usecase Policy"

  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RegisterContainerInstance",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll"
      ],
      "Resource": ["${aws_ecs_cluster.main.arn}"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "main-usecase" {
  role       = module.ec2-base.iam_role_name
  policy_arn = aws_iam_policy.main-ecs.arn
}
```

### Create global SSH key
```hcl-terraform
resource "aws_key_pair" "root_public_key" {
  key_name   = "root_public_key"
  public_key = "ssh-rsa ...== COMMENT"
}
```

### Create user group
```hcl-terraform
resource "aws_iam_group" "developers" {
  name = "developers"
}
```

## Connectivity
Install the Session Manager Plugin for the AWS CLI - https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
To start new shell session from aws cli
```bash
$ aws ssm start-session --target i-00000000000000000 --region ca-central-1 --profile default

# ~/.aws/credentials
[${name}]
aws_access_key_id = 
aws_secret_access_key = 

[${name}-${workspace}]
source_profile = ${name}
role_arn = arn:aws:iam::${SUB_ACCOUNT_ID}:role/admin
session_name = ${name}-${workspace}
```

## Input
- **vpc_id:** vpc id
- **subnet_ids:** array of public subnet ids
- **subnet_public:** is the subnet public? [Default: false]
- **image_id:** override the base image, must be CentOS based (ie has yum, rpm, docker) [Default: AWS ECS-Optimized]
- **instance_type:** override the instance type [Default: t3.micro]
- **user_data:** contents of user data to apply to the ec2 instance
- **min_size:** auto-scaling - min instance count [Default: 1]
- **max_size:** auto-scaling - max instance count [Default: 1]
- **desired_capacity:** auto-scaling - desired instance count [Default: 1]
- **key_name:** name of root ssh key, for testing only [Default: none]
- **ami_account_id:** account id of the AMI [Default: self]

## Output
- **security_group_id:** security group applied, add to ingress on private instance security group
- **iam_role_name:** IAM role name to allow extending of the role
- **iam_role_arn:** IAM role arn to allow extending of the role
- **billing_suggestion:** comments to improve billing cost


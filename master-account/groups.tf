# TODO tf v0.12 - https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each
# ${sub_account}-${role}-group

#flatten(split(",",format("%.24s", var.sub_accounts[count.index], "-", join(format("%.24s", var.sub_accounts[count.index], "-"), local.groups))))

resource "aws_iam_group" "groups" {
  count = "${length(keys(local.groups))}"
  #name = "${local.groups[count.index]}"
  name  = "${join("", list(
    upper(substr(element(split("-",local.groups[count.index]),0), 0, 1)),
    substr(element(split("-",local.groups[count.index]),0), 1, -1),
    upper(substr(element(split("-",local.groups[count.index]),1), 0, 1)),
    substr(element(split("-",local.groups[count.index]),1), 1, -1)
  ))}"
}

//# Update after v0.12.0
resource "aws_iam_policy" "groups" {
  count       = "${length(keys(local.groups))}"
  name        = "${local.groups[count.index]}-policy"
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      },
      "Resource": [
        "arn:aws:iam::${aws_organizations_account.main.*.id[index(aws_organizations_account.main.*.name, element(split("-",local.groups[count.index]),0))]}:role/${element(split("-",local.groups[count.index]),1)}"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_group_policy_attachment" "groups" {
  count      = "${length(keys(local.groups))}"
  group      = "${aws_iam_group.groups.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.groups.*.arn[count.index]}"
}

# Master Account
## Admin
resource "aws_iam_group" "admin" {
  name = "MasterAdmin"
}

resource "aws_iam_group_policy_attachment" "admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

## Billing - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-permissions-ref.html
resource "aws_iam_group" "billing" {
  name = "MasterBilling"
}

resource "aws_iam_group_policy_attachment" "billing" {
  group      = "${aws_iam_group.billing.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

## Users
resource "aws_iam_group" "users" {
  name = "User"
}

resource "aws_iam_policy" "users" {
  name        = "UserAccess"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowUsersAllActionsForCredentials",
            "Effect": "Allow",
            "Action": [
                "iam:ListAttachedUserPolicies",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:*LoginProfile",
                "iam:*AccessKey*",
                "iam:*SigningCertificate*",
                "iam:*SSHPublicKey*"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowUsersToSeeStatsOnIAMConsoleDashboard",
            "Effect": "Allow",
            "Action": [
                "iam:GetAccount*",
                "iam:ListAccount*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "AllowUsersToListUsersInConsole",
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:user/*"
            ]
        },
        {
            "Sid": "AllowUsersToListOwnGroupsInConsole",
            "Effect": "Allow",
            "Action": [
                "iam:ListGroupsForUser"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowUsersToCreateTheirOwnVirtualMFADevice",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:DeleteVirtualMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${local.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowUsersToListVirtualMFADevices",
            "Effect": "Allow",
            "Action": [
                "iam:ListMFADevices",
                "iam:ListVirtualMFADevices"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_group_policy_attachment" "users" {
  group      = "${aws_iam_group.users.name}"
  policy_arn = "${aws_iam_policy.users.arn}"
}

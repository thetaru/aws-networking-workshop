data "aws_iam_policy_document" "NetworkingWorkshopEC2PolicyDocument" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "NetworkingWorkshopEC2Role" {
  name               = "NetworkingWorkshopEC2Role"
  assume_role_policy = data.aws_iam_policy_document.NetworkingWorkshopEC2PolicyDocument.json
}

resource "aws_iam_role_policy_attachment" "NetworkingWorkshopEC2RolePolicy_Attachment_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.NetworkingWorkshopEC2Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "NetworkingWorkshopEC2RolePolicy_Attachment_AmazonS3FullAccess" {
  role       = aws_iam_role.NetworkingWorkshopEC2Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "NetworkingWorkshopInstanceProfile" {
  name = "NetworkingWorkshopInstanceProfile"
  role = aws_iam_role.NetworkingWorkshopEC2Role.name
}

data "aws_iam_policy_document" "NetworkingWorkshopFlowLogsPolicyDocument" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "NetworkingWorkshopFlowLogsRole" {
  name               = "NetworkingWorkshopFlowLogsRole"
  assume_role_policy = data.aws_iam_policy_document.NetworkingWorkshopFlowLogsPolicyDocument.json
}

data "aws_iam_policy_document" "CloudWatchLogsWritePolicyDocument" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "CloudWatchLogsWritePolicy" {
  name   = "CloudWatchLogsWritePolicy"
  role   = aws_iam_role.NetworkingWorkshopFlowLogsRole.name
  policy = data.aws_iam_policy_document.CloudWatchLogsWritePolicyDocument.json
}

data "aws_iam_policy_document" "NetworkingWorkshop_EC2_Policy_Document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "NetworkingWorkshop_EC2_Role" {
  name               = "NetworkingWorkshop_EC2_Role"
  assume_role_policy = data.aws_iam_policy_document.NetworkingWorkshop_EC2_Policy_Document.json
}

resource "aws_iam_role_policy_attachment" "NetworkingWorkshop_EC2_Role_Policy_Attachment_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.NetworkingWorkshop_EC2_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "NetworkingWorkshop_EC2_Role_Policy_Attachment_AmazonS3FullAccess" {
  role       = aws_iam_role.NetworkingWorkshop_EC2_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "NetworkingWorkshop_Instance_Profile" {
  name = "NetworkingWorkshop_Instance_Profile"
  role = aws_iam_role.NetworkingWorkshop_EC2_Role.name
}
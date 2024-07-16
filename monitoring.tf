resource "aws_cloudwatch_log_group" "NetworkingWorkshopFlowLogsGroup" {
  name = "NetworkingWorkshopFlowLogsGroup"

  retention_in_days = 0 # Never expire
}

resource "aws_flow_log" "NetworkingWorkshopFlowLog" {
  vpc_id                   = aws_vpc.VPC_A.id
  traffic_type             = "ALL"
  max_aggregation_interval = 60 # 1min
  log_destination          = aws_cloudwatch_log_group.NetworkingWorkshopFlowLogsGroup.arn
  iam_role_arn             = aws_iam_role.NetworkingWorkshopFlowLogsRole.arn

  tags = {
    Name = "NetworkingWorkshopFlowLog"
  }
}

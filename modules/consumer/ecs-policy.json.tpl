{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "${cloudwatch_log_group}:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "secretsmanager:*",
        "s3:*",
        "ecr:*",
        "ecs:*",
        "ec2:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}

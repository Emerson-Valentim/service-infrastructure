[
      {
        "cpu" : 0,
        "environment" : ${env_vars},
        "essential" : true,
        "image" : "${ecr_image}",
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "${cloudwatch_log_group}",
            "awslogs-region" : "${region}",
            "awslogs-stream-prefix" : "ecs"
          }
        },
        "mountPoints" : [],
        "name" : "notification",
        "volumesFrom" : [],
        "command" : [
          "yarn",
          "start:notification"
        ],
        "portMappings" : [
          {
            "containerPort" : 3000,
            "hostPort" : 3000,
            "protocol" : "tcp"
          }
        ]
      }
    ]
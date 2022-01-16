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
        "name" : "consumer",
        "volumesFrom" : [],
        "command" : [
          "yarn",
          "start:consumer"
        ]
      }
    ]
[
      {
        "cpu" : 0,
        "environment" : ${env_vars},
        "essential" : true,
        "image" : "${ecr_image}:latest",
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "${cloudwatch_log_group}",
            "awslogs-region" : "${region}",
            "awslogs-stream-prefix" : "ecs"
          }
        },
        "mountPoints" : [],
        "name" : "api",
        "volumesFrom" : []
      }
    ]
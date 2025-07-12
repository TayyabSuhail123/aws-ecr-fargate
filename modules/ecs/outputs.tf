output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "task_execution_role_arn" {
  value = aws_iam_role.task_execution_role.arn
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task_def.arn
}

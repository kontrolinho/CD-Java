resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "cicdjenkins"

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}
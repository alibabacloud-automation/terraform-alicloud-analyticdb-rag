output "web_application_url" {
  description = "URL to access the AI assistant web application"
  value       = module.analyticdb_rag.web_application_url
  sensitive   = true
}

output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = module.analyticdb_rag.ecs_instance_id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.analyticdb_rag.ecs_instance_public_ip
}

output "analyticdb_instance_id" {
  description = "The ID of the AnalyticDB instance"
  value       = module.analyticdb_rag.analyticdb_instance_id
}

output "analyticdb_connection_string" {
  description = "The connection string of the AnalyticDB instance"
  value       = module.analyticdb_rag.analyticdb_connection_string
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.analyticdb_rag.vpc_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.analyticdb_rag.security_group_id
}
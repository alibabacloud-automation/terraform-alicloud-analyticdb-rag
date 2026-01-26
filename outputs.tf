output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.private_ip
}

output "analyticdb_instance_id" {
  description = "The ID of the AnalyticDB instance"
  value       = alicloud_gpdb_instance.analyticdb.id
}

output "analyticdb_connection_string" {
  description = "The connection string of the AnalyticDB instance"
  value       = alicloud_gpdb_instance.analyticdb.connection_string
}

output "analyticdb_port" {
  description = "The connection port of the AnalyticDB instance"
  value       = alicloud_gpdb_instance.analyticdb.port
}

output "web_application_url" {
  description = "The URL to access the web application"
  value       = format("http://%s:%d/home", alicloud_instance.ecs_instance.public_ip, 5000)
}

output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.run_command.id
}
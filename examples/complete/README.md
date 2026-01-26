# Complete Example for AnalyticDB RAG Module

This example demonstrates how to use the AnalyticDB RAG module to create a complete AI assistant solution with AnalyticDB and Qwen.

## Architecture

This example creates:
- VPC and VSwitch for network isolation
- Security Group with rules for SSH and web application access
- ECS instance for hosting the AI application
- AnalyticDB instance for vector storage and retrieval
- Automated deployment script for the AI assistant application

## Prerequisites

1. Alibaba Cloud account with appropriate permissions
2. Bailian (DashScope) service enabled
3. Bailian application created and API key obtained

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.200.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.200.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_analyticdb_rag"></a> [analyticdb\_rag](#module\_analyticdb\_rag) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_images.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/images) | data source |
| [alicloud_zones.available](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bailian_api_key"></a> [bailian\_api\_key](#input\_bailian\_api\_key) | Bailian API key. Required for AI assistant functionality. Get it from: https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key | `string` | n/a | yes |
| <a name="input_bailian_app_id"></a> [bailian\_app\_id](#input\_bailian\_app\_id) | Bailian application ID. Required for AI assistant functionality. | `string` | n/a | yes |
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | Common name prefix for all resources | `string` | `"analyticdb-rag-example"` | no |
| <a name="input_ecs_instance_password"></a> [ecs\_instance\_password](#input\_ecs\_instance\_password) | Password for the ECS instance. Must be 8-30 characters long and contain uppercase letters, lowercase letters, numbers, and special characters. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | ECS instance type | `string` | `"ecs.g6.large"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Alibaba Cloud region where resources will be created | `string` | `"cn-zhangjiakou"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for the VPC | `string` | `"192.168.0.0/16"` | no |
| <a name="input_vswitch_cidr_block"></a> [vswitch\_cidr\_block](#input\_vswitch\_cidr\_block) | CIDR block for the VSwitch | `string` | `"192.168.0.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_analyticdb_connection_string"></a> [analyticdb\_connection\_string](#output\_analyticdb\_connection\_string) | The connection string of the AnalyticDB instance |
| <a name="output_analyticdb_instance_id"></a> [analyticdb\_instance\_id](#output\_analyticdb\_instance\_id) | The ID of the AnalyticDB instance |
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_instance_public_ip"></a> [ecs\_instance\_public\_ip](#output\_ecs\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_web_application_url"></a> [web\_application\_url](#output\_web\_application\_url) | URL to access the AI assistant web application |
<!-- END_TF_DOCS -->
Alicloud AnalyticDB RAG AI Assistant Terraform Module

# terraform-alicloud-analyticdb-rag

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-analyticdb-rag/blob/master/README-CN.md)

This module is used to implement solution [Building an AI Smart Customer Service with AnalyticDB and Qwen](https://www.aliyun.com/solution/tech-solution/analyticdb-rag). This Terraform module creates an AI-powered customer service solution using AnalyticDB for PostgreSQL and Qwen on Alibaba Cloud. This module sets up a complete RAG (Retrieval-Augmented Generation) architecture for intelligent question-answering systems, which involves the creation and deployment of resources such as Virtual Private Cloud (VPC), VSwitch, Elastic Compute Service (ECS).


## Usage


```terraform
data "alicloud_zones" "available" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = "ecs.g6.large"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

module "analyticdb_rag" {
  source = "alibabacloud-automation/analyticdb-rag/alicloud"

  common_name = "my-ai-assistant"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "ai-assistant-vpc"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.available.zones[0].id
    vswitch_name = "ai-assistant-vswitch"
  }

  security_group_config = {
    security_group_name = "ai-assistant-sg"
    security_group_type = "normal"
  }

  security_group_rules = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "22/22"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "5000/5000"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
  ]

  instance_config = {
    instance_name              = "ai-assistant-ecs"
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = "ecs.g6.large"
    system_disk_category       = "cloud_essd"
    password                   = "YourSecurePassword123!"
    internet_max_bandwidth_out = 100
  }

  gpdb_config = {
    engine                     = "gpdb"
    engine_version             = "6.0"
    instance_spec              = "4C16G"
    seg_node_num               = 2
    seg_storage_type           = "cloud_essd"
    seg_disk_performance_level = "pl1"
    storage_size               = 50
    payment_type               = "PayAsYouGo"
    db_instance_category       = "Basic"
    db_instance_mode           = "StorageElastic"
    security_ip_list           = "192.168.0.0/24"
  }

  command_config = {
    name        = "analyticdb-rag-install"
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 1800
  }

  invocation_config = {
    create_timeout = "30m"
  }

  # Optional: Custom script for AnalyticDB setup
  # custom_analyticdb_setup_script = <<-EOT
  # #!/bin/bash
  # echo "Running custom AnalyticDB setup..."
  # # Add your custom setup commands here
  # EOT

  bailian_app_id  = "your-bailian-app-id"
  bailian_api_key = "your-bailian-api-key"
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-analyticdb-rag/tree/main/examples/complete)

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

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.run_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.invoke_script](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_gpdb_instance.analyticdb](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/gpdb_instance) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bailian_api_key"></a> [bailian\_api\_key](#input\_bailian\_api\_key) | Bai Lian API key | `string` | `null` | no |
| <a name="input_bailian_app_id"></a> [bailian\_app\_id](#input\_bailian\_app\_id) | Bai Lian application ID | `string` | `null` | no |
| <a name="input_command_config"></a> [command\_config](#input\_command\_config) | Configuration for ECS command | <pre>object({<br/>    name        = string<br/>    working_dir = string<br/>    type        = string<br/>    timeout     = number<br/>  })</pre> | <pre>{<br/>  "name": "analyticdb-rag-install",<br/>  "timeout": 1800,<br/>  "type": "RunShellScript",<br/>  "working_dir": "/root"<br/>}</pre> | no |
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | Common name prefix for all resources | `string` | `"analyticdb-rag"` | no |
| <a name="input_custom_analyticdb_setup_script"></a> [custom\_analyticdb\_setup\_script](#input\_custom\_analyticdb\_setup\_script) | Custom script content for AnalyticDB setup, if not provided, the default script will be used | `string` | `null` | no |
| <a name="input_gpdb_config"></a> [gpdb\_config](#input\_gpdb\_config) | Configuration for AnalyticDB (GPDB) instance | <pre>object({<br/>    engine                     = string<br/>    engine_version             = string<br/>    instance_spec              = string<br/>    seg_node_num               = number<br/>    seg_storage_type           = string<br/>    seg_disk_performance_level = string<br/>    storage_size               = number<br/>    description                = optional(string, null)<br/>    payment_type               = string<br/>    db_instance_category       = string<br/>    db_instance_mode           = string<br/>    security_ip_list           = string<br/>  })</pre> | <pre>{<br/>  "db_instance_category": "Basic",<br/>  "db_instance_mode": "StorageElastic",<br/>  "engine": "gpdb",<br/>  "engine_version": "6.0",<br/>  "instance_spec": "4C16G",<br/>  "payment_type": "PayAsYouGo",<br/>  "security_ip_list": "192.168.0.0/24",<br/>  "seg_disk_performance_level": "pl1",<br/>  "seg_node_num": 2,<br/>  "seg_storage_type": "cloud_essd",<br/>  "storage_size": 50<br/>}</pre> | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | Configuration for ECS instance. The attributes 'image\_id', 'instance\_type', 'system\_disk\_category', 'password', and 'internet\_max\_bandwidth\_out' are required. | <pre>object({<br/>    instance_name              = optional(string, null)<br/>    image_id                   = string<br/>    instance_type              = string<br/>    system_disk_category       = string<br/>    password                   = string<br/>    internet_max_bandwidth_out = number<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": "ecs.g6.large",<br/>  "internet_max_bandwidth_out": 100,<br/>  "password": null,<br/>  "system_disk_category": "cloud_essd"<br/>}</pre> | no |
| <a name="input_invocation_config"></a> [invocation\_config](#input\_invocation\_config) | Configuration for ECS command invocation | <pre>object({<br/>    create_timeout = string<br/>  })</pre> | <pre>{<br/>  "create_timeout": "30m"<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for security group | <pre>object({<br/>    security_group_name = optional(string, null)<br/>    security_group_type = string<br/>  })</pre> | <pre>{<br/>  "security_group_type": "normal"<br/>}</pre> | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | The parameters of security group rules. The attributes 'type', 'ip\_protocol', 'nic\_type', 'policy', 'port\_range', 'priority', 'cidr\_ip' are required. | <pre>list(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    nic_type    = string<br/>    policy      = string<br/>    port_range  = string<br/>    priority    = number<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "22/22",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  },<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "5000/5000",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    cidr_block = optional(string, "192.168.0.0/16")<br/>    vpc_name   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | Configuration for VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = optional(string, "192.168.0.0/24")<br/>    zone_id      = string<br/>    vswitch_name = optional(string, null)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_analyticdb_connection_string"></a> [analyticdb\_connection\_string](#output\_analyticdb\_connection\_string) | The connection string of the AnalyticDB instance |
| <a name="output_analyticdb_instance_id"></a> [analyticdb\_instance\_id](#output\_analyticdb\_instance\_id) | The ID of the AnalyticDB instance |
| <a name="output_analyticdb_port"></a> [analyticdb\_port](#output\_analyticdb\_port) | The connection port of the AnalyticDB instance |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_instance_private_ip"></a> [ecs\_instance\_private\_ip](#output\_ecs\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_ecs_instance_public_ip"></a> [ecs\_instance\_public\_ip](#output\_ecs\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
| <a name="output_web_application_url"></a> [web\_application\_url](#output\_web\_application\_url) | The URL to access the web application |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
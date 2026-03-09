Alibaba Cloud AnalyticDB RAG AI 智能助手 Terraform 模块

# terraform-alicloud-analyticdb-rag

[English](https://github.com/alibabacloud-automation/terraform-alicloud-analyticdb-rag/blob/master/README.md) | 简体中文

本模块用于实现解决方案[AnalyticDB与通义千问搭建AI智能客服](https://www.aliyun.com/solution/tech-solution/analyticdb-rag)，使用 AnalyticDB for PostgreSQL 和通义千问在阿里云上创建 AI 智能客服解决方案。本模块建立完整的 RAG（检索增强生成）架构，用于智能问答系统，涉及到专有网络（VPC）、交换机（VSwitch）、云服务器（ECS）等资源的创建。


## 使用方法

```terraform
data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

module "analyticdb_rag" {
  source = "alibabacloud-automation/analyticdb-rag/alicloud"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
  }

  vswitch_config = {
    zone_id = data.alicloud_zones.available.zones[0].id
  }

  instance_config = {
    image_id = data.alicloud_images.default.images[0].id
    password = "YourSecurePassword123!"
  }

  bailian_app_id  = "your-bailian-app-id"
  bailian_api_key = "your-bailian-api-key"
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-analyticdb-rag/tree/main/examples/complete)


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
| <a name="input_bailian_api_key"></a> [bailian\_api\_key](#input\_bailian\_api\_key) | Alibaba Cloud Bailian (Model Studio) API key. Required for RAG application integration. | `string` | n/a | yes |
| <a name="input_bailian_app_id"></a> [bailian\_app\_id](#input\_bailian\_app\_id) | Alibaba Cloud Bailian (Model Studio) application ID. Required for RAG application integration. | `string` | n/a | yes |
| <a name="input_command_config"></a> [command\_config](#input\_command\_config) | ECS Cloud Assistant command configuration. Timeout is in seconds (default: 1800s = 30 minutes). | <pre>object({<br/>    name        = optional(string, "analyticdb-rag-install")<br/>    working_dir = optional(string, "/root")<br/>    type        = optional(string, "RunShellScript")<br/>    timeout     = optional(number, 1800)<br/>  })</pre> | `{}` | no |
| <a name="input_custom_analyticdb_setup_script"></a> [custom\_analyticdb\_setup\_script](#input\_custom\_analyticdb\_setup\_script) | Custom bash script for AnalyticDB RAG application deployment. If not provided, the default embedded script will be used. | `string` | `null` | no |
| <a name="input_gpdb_config"></a> [gpdb\_config](#input\_gpdb\_config) | AnalyticDB for PostgreSQL (GPDB) instance configuration. All attributes have reasonable defaults for a basic setup. | <pre>object({<br/>    engine                     = optional(string, "gpdb")<br/>    engine_version             = optional(string, "6.0")<br/>    instance_spec              = optional(string, "4C16G")<br/>    seg_node_num               = optional(number, 2)<br/>    seg_storage_type           = optional(string, "cloud_essd")<br/>    seg_disk_performance_level = optional(string, "pl1")<br/>    storage_size               = optional(number, 50)<br/>    description                = optional(string, null)<br/>    payment_type               = optional(string, "PayAsYouGo")<br/>    db_instance_category       = optional(string, "Basic")<br/>    db_instance_mode           = optional(string, "StorageElastic")<br/>    security_ip_list           = optional(string, "192.168.0.0/24")<br/>  })</pre> | `{}` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | ECS instance configuration. The image\_id and password are required. Recommended image: Alibaba Cloud Linux 3.2104 LTS 64-bit. | <pre>object({<br/>    instance_name              = optional(string, null)<br/>    image_id                   = string<br/>    instance_type              = optional(string, "ecs.g6.large")<br/>    system_disk_category       = optional(string, "cloud_essd")<br/>    password                   = string<br/>    internet_max_bandwidth_out = optional(number, 100)<br/>  })</pre> | n/a | yes |
| <a name="input_invocation_config"></a> [invocation\_config](#input\_invocation\_config) | ECS command invocation configuration. Timeout format: Xs (seconds), Xm (minutes), Xh (hours). | <pre>object({<br/>    create_timeout = optional(string, "30m")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Security group configuration. Includes optional name and type. | <pre>object({<br/>    security_group_name = optional(string, null)<br/>    security_group_type = optional(string, "normal")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | List of security group rules. Default rules allow SSH (port 22) and application access (port 5000). | <pre>list(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    nic_type    = string<br/>    policy      = string<br/>    port_range  = string<br/>    priority    = number<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "22/22",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  },<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "5000/5000",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration. Includes CIDR block and optional VPC name. | <pre>object({<br/>    cidr_block = optional(string, "192.168.0.0/16")<br/>    vpc_name   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | VSwitch configuration. The zone\_id is required and cannot be changed after creation. | <pre>object({<br/>    cidr_block   = optional(string, "192.168.0.0/24")<br/>    zone_id      = string<br/>    vswitch_name = optional(string, null)<br/>  })</pre> | n/a | yes |

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

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
variable "vpc_config" {
  type = object({
    cidr_block = optional(string, "192.168.0.0/16")
    vpc_name   = optional(string, null)
  })
  description = "VPC configuration. Includes CIDR block and optional VPC name."
}

variable "vswitch_config" {
  type = object({
    cidr_block   = optional(string, "192.168.0.0/24")
    zone_id      = string
    vswitch_name = optional(string, null)
  })
  description = "VSwitch configuration. The zone_id is required and cannot be changed after creation."
}

variable "security_group_config" {
  type = object({
    security_group_name = optional(string, null)
    security_group_type = optional(string, "normal")
  })
  description = "Security group configuration. Includes optional name and type."
  default     = {}
}

variable "security_group_rules" {
  type = list(object({
    type        = string
    ip_protocol = string
    nic_type    = string
    policy      = string
    port_range  = string
    priority    = number
    cidr_ip     = string
  }))
  description = "List of security group rules. Default rules allow SSH (port 22) and application access (port 5000)."
  default = [
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
}

variable "instance_config" {
  type = object({
    instance_name              = optional(string, null)
    image_id                   = string
    instance_type              = optional(string, "ecs.g6.large")
    system_disk_category       = optional(string, "cloud_essd")
    password                   = string
    internet_max_bandwidth_out = optional(number, 100)
  })
  description = "ECS instance configuration. The image_id and password are required. Recommended image: Alibaba Cloud Linux 3.2104 LTS 64-bit."
}

variable "gpdb_config" {
  type = object({
    engine                     = optional(string, "gpdb")
    engine_version             = optional(string, "6.0")
    instance_spec              = optional(string, "4C16G")
    seg_node_num               = optional(number, 2)
    seg_storage_type           = optional(string, "cloud_essd")
    seg_disk_performance_level = optional(string, "pl1")
    storage_size               = optional(number, 50)
    description                = optional(string, null)
    payment_type               = optional(string, "PayAsYouGo")
    db_instance_category       = optional(string, "Basic")
    db_instance_mode           = optional(string, "StorageElastic")
    security_ip_list           = optional(string, "192.168.0.0/24")
  })
  description = "AnalyticDB for PostgreSQL (GPDB) instance configuration. All attributes have reasonable defaults for a basic setup."
  default     = {}
}

variable "custom_analyticdb_setup_script" {
  type        = string
  description = "Custom bash script for AnalyticDB RAG application deployment. If not provided, the default embedded script will be used."
  default     = null
}

variable "command_config" {
  type = object({
    name        = optional(string, "analyticdb-rag-install")
    working_dir = optional(string, "/root")
    type        = optional(string, "RunShellScript")
    timeout     = optional(number, 1800)
  })
  description = "ECS Cloud Assistant command configuration. Timeout is in seconds (default: 1800s = 30 minutes)."
  default     = {}
}

variable "bailian_app_id" {
  type        = string
  description = "Alibaba Cloud Bailian (Model Studio) application ID. Required for RAG application integration."
}

variable "bailian_api_key" {
  type        = string
  description = "Alibaba Cloud Bailian (Model Studio) API key. Required for RAG application integration."
  sensitive   = true
}

variable "invocation_config" {
  type = object({
    create_timeout = optional(string, "30m")
  })
  description = "ECS command invocation configuration. Timeout format: Xs (seconds), Xm (minutes), Xh (hours)."
  default     = {}
}

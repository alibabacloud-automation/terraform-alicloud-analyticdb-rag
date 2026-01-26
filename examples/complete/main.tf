# Configure the Alicloud Provider
provider "alicloud" {
  region = var.region
}

# Data sources for dynamic resource selection
data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

# Call the AnalyticDB RAG module
module "analyticdb_rag" {
  source = "../../"

  vpc_config = {
    cidr_block = var.vpc_cidr_block
    vpc_name   = "vpc_${var.common_name}"
  }

  vswitch_config = {
    cidr_block   = var.vswitch_cidr_block
    zone_id      = var.zone_id
    vswitch_name = "vsw_${var.common_name}"
  }

  security_group_config = {
    security_group_name = "${var.common_name}-sg"
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
      cidr_ip     = var.vpc_cidr_block
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "5000/5000"
      priority    = 1
      cidr_ip     = var.vpc_cidr_block
    }
  ]

  instance_config = {
    instance_name              = "${var.common_name}-ecs_adb"
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.instance_type
    system_disk_category       = "cloud_essd"
    password                   = var.ecs_instance_password
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
    description                = "${var.common_name}-adb"
    payment_type               = "PayAsYouGo"
    db_instance_category       = "Basic"
    db_instance_mode           = "StorageElastic"
    security_ip_list           = var.vswitch_cidr_block
  }

  bailian_app_id  = var.bailian_app_id
  bailian_api_key = var.bailian_api_key

  # Command and invocation timeout configurations
  command_config = {
    name        = "adb-bailian-install"
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 7200 # 2 hours (7200 seconds)
  }

  invocation_config = {
    create_timeout = "120m" # 2 hours
  }
}
locals {
  default_analyticdb_setup_script = <<EOF
#!/bin/bash

# script exit code:
# 0 - success
# 1 - unsupported system
# 2 - network not available
# 3 - failed to git clone
# 4 - failed to init python environment
# 5 - failed to init git
# 6 - failed to run flask app

# 环境变量配置
cat << EOT >> ~/.bashrc
export SOCKET_ENDPOINT=${alicloud_instance.ecs_instance.public_ip}:5000
export APP_ID=${var.bailian_app_id}
export DASHSCOPE_API_KEY=${var.bailian_api_key}
EOT
source ~/.bashrc

# 检查是否已经配置过
if [ ! -f .ros.provision ]; then
  echo "Name: 手动搭建AnalyticDB与百炼搭建智能问答系统" > .ros.provision
fi

name=$(grep "^Name:" .ros.provision | awk -F':' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
if [[ "$name" != "手动搭建AnalyticDB与百炼搭建智能问答系统" ]]; then
  echo "当前实例已使用过\"$name\"教程的一键配置，不能再使用本教程的一键配置"
  exit 1
fi

# Step1: Prepare Environment
if ! grep -q "^Step1: Prepare Environment$" .ros.provision; then
  echo "#########################"
  echo "# Prepare Environment "
  echo "#########################"
  
  # 安装Python-3.9.7
  sudo yum update -y && \
  sudo yum groupinstall "Development Tools" -y && \
  sudo yum install openssl-devel bzip2-devel libffi-devel -y
  
  cd /usr/src && \
  sudo curl -O https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20240729/unpfxr/Python-3.9.0.tgz && \
  sudo tar xzf Python-3.9.0.tgz && \
  cd Python-3.9.0 && \
  sudo ./configure --enable-optimizations && \
  sudo make altinstall

  python3.9 --version && \
  python3.9 -m ensurepip && \
  python3.9 -m pip install --upgrade pip

  echo "Step1: Prepare Environment" >> .ros.provision
else
  echo "#########################"
  echo "# Environment has been ready"
  echo "#########################"
fi

# Step2: Deployment service
if ! grep -q "^Step2: Deployment service$" .ros.provision; then
  echo "#########################"
  echo "# Deployment service "
  echo "#########################"
  
  cd /root
  wget https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20240729/unpfxr/demo.zip
  sudo yum install -y unzip
  unzip demo.zip
  cd demo
  python3.9 -m venv $(pwd)/venv
  source $(pwd)/venv/bin/activate
  pip3 install -r requirements.txt
  # 解决Python包版本兼容性问题
  # 1. 卸载可能存在问题的包
  pip3 uninstall -y aiohttp flask-socketio python-socketio
  # 2. 安装已知兼容的特定版本
  pip3 install aiohttp==3.8.1 flask-socketio==5.3.0 python-socketio==5.6.0
  sed "s/socketio.run(app, debug=True, host='0.0.0.0')/socketio.run(app, debug=True, host='0.0.0.0', allow_unsafe_werkzeug=True)/" app-stream.py > temp_app_stream.py
  mv temp_app_stream.py app-stream.py
  rm -rf temp_app_stream.py
  nohup python3.9 app-stream.py > app-stream.log 2>&1 &
  
  echo "Step2: Deployment service" >> .ros.provision
else
  echo "#########################"
  echo "# Service deployed"
  echo "#########################"
fi

echo "Deployment completed successfully!"
EOF
}

# VPC
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# VSwitch
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Security Group
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  security_group_type = var.security_group_config.security_group_type
}

# Security Group Rules
resource "alicloud_security_group_rule" "rules" {
  for_each          = { for rule in var.security_group_rules : "${rule.type}-${rule.ip_protocol}-${rule.port_range}-${rule.cidr_ip}" => rule }
  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
}

# ECS Instance
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.instance_config.instance_name
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  system_disk_category       = var.instance_config.system_disk_category
  vswitch_id                 = alicloud_vswitch.vswitch.id
  security_groups            = [alicloud_security_group.security_group.id]
  password                   = var.instance_config.password
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
}

# AnalyticDB Instance
resource "alicloud_gpdb_instance" "analyticdb" {
  engine                     = var.gpdb_config.engine
  engine_version             = var.gpdb_config.engine_version
  instance_spec              = var.gpdb_config.instance_spec
  zone_id                    = alicloud_vswitch.vswitch.zone_id
  vswitch_id                 = alicloud_vswitch.vswitch.id
  seg_node_num               = var.gpdb_config.seg_node_num
  seg_storage_type           = var.gpdb_config.seg_storage_type
  seg_disk_performance_level = var.gpdb_config.seg_disk_performance_level
  storage_size               = var.gpdb_config.storage_size
  vpc_id                     = alicloud_vpc.vpc.id
  description                = var.gpdb_config.description
  payment_type               = var.gpdb_config.payment_type
  db_instance_category       = var.gpdb_config.db_instance_category
  db_instance_mode           = var.gpdb_config.db_instance_mode

  ip_whitelist {
    security_ip_list = var.gpdb_config.security_ip_list
  }
}

# ECS Command for application deployment
resource "alicloud_ecs_command" "run_command" {
  name            = var.command_config.name
  command_content = base64encode(var.custom_analyticdb_setup_script != null ? var.custom_analyticdb_setup_script : local.default_analyticdb_setup_script)
  working_dir     = var.command_config.working_dir
  type            = var.command_config.type
  timeout         = var.command_config.timeout
}

# Execute command on ECS instance
resource "alicloud_ecs_invocation" "invoke_script" {
  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.run_command.id
  timeouts {
    create = var.invocation_config.create_timeout
  }
}
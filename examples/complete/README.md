# Complete Example

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

## Usage

To run this example, you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Cost Notice

The resources created by this example will incur charges. Please review the pricing for:
- ECS instances
- AnalyticDB for PostgreSQL instances
- VPC and network resources
- Public bandwidth usage

# HAProxy Enterprise WAF sample project

Demonstrates using the HAProxy Enterprise WAF module.

## How to Use

Follow these steps:

1. In the [AWS Console](https://console.aws.amazon.com), create a new SSH keypair via **EC2 > Key Pairs > Create Key Pair**. Name the keypair *haproxy_demo*. Save the PEM file to this project's directory.
3. Install Terraform and then run:

```
terraform init
terraform apply -auto-approve -var "aws_access_key=[YOUR ACCESS KEY]" -var "aws_secret_key=[YOUR SECRET ACCESS KEY]" -var "my_source_ip=[YOUR SOURCE IP]"
```

This will create resources in AWS EC2. Be sure to tear down this infrastructure when you are finished so that you don't incur extra charges. Use `terraform destroy`.

```
terraform destroy -auto-approve -var "aws_access_key=[YOUR ACCESS KEY]" -var "aws_secret_key=[YOUR SECRET ACCESS KEY]" -var "my_source_ip=[YOUR SOURCE IP]"
```

4. Access the web application via HAProxy's public IP address.
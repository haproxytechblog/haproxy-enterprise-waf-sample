# HAProxy Enterprise WAF sample project

Demonstrates using the HAProxy Enterprise WAF module.

## How to Use

Follow these steps:

1. In the [AWS Console](https://console.aws.amazon.com), create a new SSH keypair via **EC2 > Key Pairs > Create Key Pair**. Name the keypair *haproxy_demo*. Save the PEM file to this project's directory.
2. Update the **variables.tf** file so that its *aws_region` variable specifies the AWS region where you created your SSH key pair. Note that not all regions support all instance sizes.
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

## Configure the HAProxy WAF module

1. SSH into the VM

```
ssh -i ./haproxy_demo.pem ubuntu@[HAPROXY_IP_ADDRESS]
```

2. Install the Modsecurity Core Rule Set

```
sudo /opt/hapee-1.8/bin/hapee-lb-modsecurity-getcrs
```

3. Update /etc/hapee-1.8/hapee-lb.cfg, adding the following to the `global` section:

```
module-load hapee-lb-modsecurity.so
```

and the following to the 'frontend' section:

```
filter modsecurity owasp_crs rules-file /etc/hapee-1.8/modsec.rules.d/lb-modsecurity.conf
```

4. Update /etc/hapee-1.8/modsec.rules.d/modsecurity.conf, changing `SecRuleEngine DetectionOnly` to `SecRuleEngine On`.

5. Restart HAproxy

```
sudo hapee-1.8 restart
```
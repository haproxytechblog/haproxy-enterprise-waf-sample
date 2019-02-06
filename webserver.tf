resource "aws_instance" "webserver" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.aws_instance_type}"
  subnet_id              = "${aws_subnet.haproxy_demo.id}"
  vpc_security_group_ids = ["${aws_security_group.haproxy_demo.id}"]
  key_name               = "${var.ssh_keypair_name}"
  private_ip             = "192.168.0.10"

  tags {
    Name = "webserver"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./${var.ssh_keypair_name}.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
        "echo 127.0.0.1 $(hostname) | sudo tee -a /etc/hosts",
        "sudo apt update > /dev/null",
        "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common > /dev/null",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
        "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'",
        "sudo apt update > /dev/null",
        "sudo apt install -y docker-ce > /dev/null",
        "sudo docker run --name dvwa -d -p 80:80 vulnerables/web-dvwa",
    ]
  }
}

output "webserver_public_ip" {
  value = "${aws_instance.webserver.public_ip}"
}

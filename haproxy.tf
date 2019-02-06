resource "aws_instance" "haproxy" {
  ami                    = "${data.aws_ami.haproxy_enterprise.id}"
  instance_type          = "${var.aws_instance_type}"
  subnet_id              = "${aws_subnet.haproxy_demo.id}"
  vpc_security_group_ids = ["${aws_security_group.haproxy_demo.id}"]
  key_name               = "${var.ssh_keypair_name}"
  depends_on             = ["aws_instance.webserver"]

  tags {
    Name = "haproxy"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./${var.ssh_keypair_name}.pem")}"
  }

  provisioner "file" {
    source      = "./haproxy/hapee-lb.cfg"
    destination = "/home/ubuntu/hapee-lb.cfg"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo cp -f /home/ubuntu/hapee-lb.cfg /etc/hapee-1.8/hapee-lb.cfg",
        "sudo systemctl reload hapee-1.8-lb",
    ]
  }
}

output "haproxy_public_ip" {
  value = "${aws_instance.haproxy.public_ip}"
}

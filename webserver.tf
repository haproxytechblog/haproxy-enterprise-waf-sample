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

  provisioner "file" {
    source      = "./install_dvwa.sh"
    destination = "/tmp/install_dvwa.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/install_dvwa.sh",
        "sudo /tmp/install_dvwa.sh",
    ]
  }
}

output "webserver_public_ip" {
  value = "${aws_instance.webserver.public_ip}"
}

resource "aws_instance" "awsredrive01" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "admin"
  }
  instance_type          = "t2.micro"
  ami                    = "ami-0bf9ef4c7f3e35044"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.xeasgnmnt-SG.id]
  subnet_id              = aws_subnet.xeasgnmnt-subnet-v1a.id
  private_ip             = "10.10.1.4"

  tags = {
    Name = "awsredrive01"
  }

  root_block_device {
    volume_size = "15"
    volume_type = "gp2"
  }

  provisioner "file" {
    source      = "install_awsredrive.sh"
    destination = "/tmp/install_awsredrive.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_awsredrive.sh",
      "sudo /tmp/install_awsredrive.sh",
    ]
  }
}

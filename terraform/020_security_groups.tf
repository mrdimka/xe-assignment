# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "xeasgnmnt-SG" {
  name        = "xeasgnmnt-SG"
  description = "Used for XE assignment"
  vpc_id      = aws_vpc.xeasgnmnt-vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access from anywhere"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "awsredrive01_public_ip" {
  description = "List of public IP address assigned to the instances"
  value       = [aws_instance.awsredrive01.*.public_ip]
}


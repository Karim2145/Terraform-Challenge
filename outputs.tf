output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.Lab7_VPC.id
}
output "alb_dns_name" {
    description = "DNS name of the Application Load Balancer"
    value = aws_lb.Web_ALB.dns_name
}
output "bastion_public_ip" {
    description = "Public IP of the bastion host"
    value = aws_instance.Bastion.public_ip
}
output "db_host_ssm_path" {
    description = "SSM path for the database Host"
    value = aws_ssm_parameter.db_host.id
}
output "db_password_ssm_path" {
    description = "SSM path for the database password"
    value = aws_ssm_parameter.db_password.id
}
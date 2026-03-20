# == Security Groups ==

resource "aws_security_group" "Bastion_SG" {
    name = "Bastion_SG"
    description = "SSH to the EC2 instances from my IP"
    vpc_id = aws_vpc.Lab7_VPC.id
    ingress  {
        to_port = 22
        from_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_IP]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Bastion_SG"
    }
}
resource "aws_security_group" "ALB_SG" {
    name = "ALB_SG"
    description = "Allow HTTP from anywhere on the Internet"
    vpc_id = aws_vpc.Lab7_VPC.id
    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ALB_SG"
    }
}
resource "aws_security_group" "Web_SG" {
    name = "Web_SG"
    description = "Allow HTTP to the web servers"
    vpc_id = aws_vpc.Lab7_VPC.id
    ingress {
        description = "Incoming HTTP from ALB"
        to_port = 80
        from_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.ALB_SG.id]
    }
    ingress {
        description = "Incoming SSH connection from Bastion"
        to_port = 22
        from_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.Bastion_SG.id]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Web_SG"
    }
}

resource "aws_security_group" "Backend_ALB_SG" {
    name = "Backend_ALB_SG"
    description = "HTTP from web tier to backend"
    vpc_id = aws_vpc.Lab7_VPC.id
    ingress {
        description = "HTTP from WEB"
        to_port = 3000
        from_port = 3000
        protocol = "tcp"
        security_groups = [aws_security_group.Web_SG.id]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Backend_ALB_SG"
    }
}


resource "aws_security_group" "Backend_SG" {
    name = "Backend_SG"
    description = "SSH into the backend from bastion + HTTP from web"
    vpc_id = aws_vpc.Lab7_VPC.id
    ingress {
        description = "SSH from Bastion"
        to_port = 22
        from_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.Bastion_SG.id]
    }
    ingress {
        description = "HTTP from WEB ALB"
        to_port = 3000
        from_port = 3000
        protocol = "tcp"
        security_groups = [aws_security_group.Backend_ALB_SG.id]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Backend_SG"
    }
}

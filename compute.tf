# == Latest Amazon Linux 2023 AMI ==
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}    
# == Bastion == 

resource "aws_instance" "Bastion" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.Public_1.id
    vpc_security_group_ids = [aws_security_group.Bastion_SG.id]
    key_name = var.my_key
    tags = { Name = "Bastion-Host" }
}

# == Web servers ==

# == Launch Template ==
resource "aws_launch_template" "Web_LT" {
    name_prefix = "Web-LT"
    image_id = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro"
    key_name = var.my_key
    vpc_security_group_ids = [aws_security_group.Web_SG.id]
    user_data = base64encode(replace(file("${path.module}/userdata/web.sh"), "Backend_IP:3000", "${aws_lb.Backend_ALB.dns_name}:3000"))
    iam_instance_profile {
        name = aws_iam_instance_profile.ec2_ssm.name
    }
    tag_specifications {
        resource_type = "instance"
        tags = { Name = "ASG-Web-Server" }
    }
}
# == Auto Scaling Group ==
resource "aws_autoscaling_group" "Web_ASG" {
    name = "ASG_Web"
    desired_capacity = 2
    min_size = 1
    max_size = 4
    vpc_zone_identifier = [aws_subnet.Public_1.id, aws_subnet.Public_2.id]
    target_group_arns = [aws_lb_target_group.Web_TG.arn]
    launch_template {
        id = aws_launch_template.Web_LT.id
        version = "$Latest"
    }
    health_check_type = "ELB"
    tag {
        key = "Name"
        value = "ASG-Web-Server"
        propagate_at_launch = true
    }
}


# =======================================================

# == Backend servers ==

# == Launch Template ==
resource "aws_launch_template" "Backend_LT" {
    name_prefix = "Backend-LT"
    image_id = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro"
    key_name = var.my_key
    vpc_security_group_ids = [aws_security_group.Backend_SG.id]
    user_data = filebase64("${path.module}/userdata/backend.sh")
    iam_instance_profile {
        name = aws_iam_instance_profile.ec2_ssm.name
    }
    tag_specifications {
        resource_type = "instance"
        tags = { Name = "ASG-Backend-Server" }
    }
}
# == Auto Scaling Group ==
resource "aws_autoscaling_group" "Backend_ASG" {
    name = "ASG_Backend"
    desired_capacity = 2
    min_size = 1
    max_size = 3
    vpc_zone_identifier = [aws_subnet.Private_1.id, aws_subnet.Private_2.id]
    target_group_arns = [aws_lb_target_group.Backend_TG.arn]
    launch_template {
        id = aws_launch_template.Backend_LT.id
        version = "$Latest"
    }
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "ASG-Backend-Server"
        propagate_at_launch = true
    }
}

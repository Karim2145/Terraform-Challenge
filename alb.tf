# == Application Load Balancer ==
resource "aws_lb" "Web_ALB" {
    name = "ALB"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.ALB_SG.id]
    subnets = [aws_subnet.Public_1.id, aws_subnet.Public_2.id]
    tags = { Name = "ALB" }
}
# == Target Group ==
resource "aws_lb_target_group" "Web_TG" {
    name = "Web-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.Lab7_VPC.id
    target_type = "instance"
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
    }
    tags = { Name = "Web_TG" }
}

# == Listener ==
resource "aws_lb_listener" "Web" {
    load_balancer_arn = aws_lb.Web_ALB.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.Web_TG.arn
    }
}

# == Internal ALB (Backend) ==
resource "aws_lb" "Backend_ALB" {
    name = "Backend-ALB"
    internal = true
    load_balancer_type = "application"
    security_groups = [aws_security_group.Backend_ALB_SG.id]
    subnets = [aws_subnet.Private_1.id, aws_subnet.Private_2.id]
    tags = { Name = "Backend-ALB" }
}
resource "aws_lb_target_group" "Backend_TG" {
    name = "Backend-TG"
    port = 3000
    protocol = "HTTP"
    vpc_id = aws_vpc.Lab7_VPC.id
    target_type = "instance"
    health_check {
        path = "/api/health"
        protocol = "HTTP"
        matcher = "200"
    }
    tags = { Name = "Backend_TG" }
}
resource "aws_lb_listener" "Backend" {
    load_balancer_arn = aws_lb.Backend_ALB.arn
    port = 3000
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.Backend_TG.arn
    }
}
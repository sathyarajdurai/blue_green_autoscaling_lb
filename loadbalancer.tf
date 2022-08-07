resource "aws_lb" "blue_green_lb" {
  name               = "blue-green-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public.id, data.aws_subnet.public1.id]
  security_groups    = [data.aws_security_group.bl_gr_server.id]
}

resource "aws_lb_listener" "blue_listener" {
  load_balancer_arn = aws_lb.blue_green_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.blue_tg.id
        weight = 50
      }
    
    target_group {
      arn    = aws_lb_target_group.green_tg.id
      weight = 50
      }
    }
  }
}

resource "aws_lb_target_group" "blue_tg" {
  name     = "blue-tg-lb"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_lb.id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

# resource "aws_lb_target_group_attachment" "blue_tg_attach" {
#   #count            = length(aws_instance.blue)
#   target_group_arn = aws_lb_target_group.blue_tg.arn
#   target_id        = aws_autoscaling_group.blue_asg.arn
#   port             = 80

#   depends_on = [aws_autoscaling_group.blue_asg]
# }

resource "aws_autoscaling_attachment" "blue_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.blue_asg.id
  lb_target_group_arn    = aws_lb_target_group.blue_tg.arn
}



resource "aws_lb_target_group" "green_tg" {
  name     = "green-tg-lb"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_lb.id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

# resource "aws_lb_target_group_attachment" "green_tg_attach" {
#   #count            = length(aws_instance.green)
#   target_group_arn = aws_lb_target_group.green_tg.arn
#   target_id        = aws_autoscaling_group.green_asg.arn
#   port             = 80
#   depends_on = [aws_autoscaling_group.green_asg]
# }

resource "aws_autoscaling_attachment" "green_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.green_asg.id
  lb_target_group_arn    = aws_lb_target_group.green_tg.arn
}
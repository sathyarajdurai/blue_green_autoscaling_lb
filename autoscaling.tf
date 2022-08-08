
resource "aws_launch_configuration" "blue_conf" {
  name                 = "blue-config"
  image_id             = data.aws_ami.blue_id.id
  instance_type        = "t2.micro"
  key_name             = data.aws_key_pair.eu_key.key_name
  security_groups      = [data.aws_security_group.bl_gr_server.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.id
  user_data = <<EOF
  #!/bin/bash
  sudo su apt-get update
  sudo su apt-get install stress
  sleep 600
  stress --cpu 2 --timeout 600
  EOF
}

resource "aws_autoscaling_group" "blue_asg" {
  name                      = "blue-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.blue_conf.name
  vpc_zone_identifier       = [data.aws_subnet.private.id]

  tag {
    key                 = "Name"
    value               = "blue-server-${timestamp()}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "blue_asg_policy" {
  name                   = "blue-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.blue_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_blue" {
  alarm_name          = "cpu-alarm-blue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 40
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.blue_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.blue_asg_policy.arn]
}

resource "aws_autoscaling_policy" "blue_asg_policy_scaledown" {
  name                   = "blue-asg-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.blue_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_blue_scaledown" {
  alarm_name          = "cpu-alarm-blue-scaledown"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.blue_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.blue_asg_policy_scaledown.arn]
}

resource "aws_launch_configuration" "green_conf" {
  name                 = "green-config"
  image_id             = data.aws_ami.green_id.id
  instance_type        = "t2.micro"
  key_name             = data.aws_key_pair.eu_key.key_name
  security_groups      = [data.aws_security_group.bl_gr_server.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.id
  user_data = <<EOF
  #!/bin/bash
  sudo su apt-get update
  sudo su apt-get install stress
  sleep 600
  stress --cpu 2 --timeout 600
  EOF
}

resource "aws_autoscaling_group" "green_asg" {
  name                      = "green-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.green_conf.name
  vpc_zone_identifier       = [data.aws_subnet.private1.id]

  tag {
    key                 = "Name"
    value               = "green-server-${timestamp()}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "green_asg_policy" {
  name                   = "green-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.green_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_green" {
  alarm_name          = "cpu-alarm-green"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 40
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.green_asg_policy.arn]
}

resource "aws_autoscaling_policy" "green_asg_policy_scaledown" {
  name                   = "green-asg-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.green_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_green_scaledown" {
  alarm_name          = "cpu-alarm-green-scaledown"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.green_asg_policy_scaledown.arn]
}


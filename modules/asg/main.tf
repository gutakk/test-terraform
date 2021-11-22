resource "aws_iam_instance_profile" "app_instance" {
  name = "${var.namespace}-instance"
  role = aws_iam_role.app_instance.name
}

resource "aws_iam_role" "app_instance" {
  name               = "${var.namespace}-instance"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "app_instance_ecs_policy" {
  role       = aws_iam_role.app_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_launch_configuration" "lc" {
  name                        = "${var.namespace}-lc"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.app_instance.name
  key_name                    = var.key_name
  security_groups             = var.security_group_ids
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "asg" {
  name                  = "${var.namespace}-asg"
  launch_configuration  = aws_launch_configuration.lc.name
  min_size              = var.min_instance_size
  max_size              = var.max_instance_size
  desired_capacity      = var.instance_desired_capacity
  vpc_zone_identifier   = var.vpc_zone
  target_group_arns     = [var.alb_target_group_arn]
  protect_from_scale_in = true
  force_delete          = true
}

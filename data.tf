data "aws_ami" "blue_id" {

  filter {
    name   = "name"
    values = ["AMI-BUILD-Blue-*"]
  }

  owners = ["151926427169"] # Canonical
}

output "id" {
  value = data.aws_ami.blue_id.id

}

data "aws_key_pair" "eu_key" {
  key_name = "talent-academy-lab"
  # key_pair_id = "key-08d8843f51fea4712"
  include_public_key = true

}

output "key" {
  value = data.aws_key_pair.eu_key.id
}

data "aws_security_group" "bl_gr_server" {
  filter {
    name   = "tag:Name"
    values = ["Blue-Green-Server"]
  }
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["private"]
  }
}

data "aws_subnet" "private1" {
  filter {
    name   = "tag:Name"
    values = ["private1"]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["public"]
  }
}

data "aws_subnet" "public1" {
  filter {
    name   = "tag:Name"
    values = ["public1"]
  }
}

data "aws_vpc" "vpc_lb" {
  filter {
    name   = "tag:Name"
    values = ["blue-green-deploy"]
  }
}

data "aws_instance" "blue_inst" {
  # instance_id = "*"
  #instance_state = "running"
  filter {
    name   = "tag:Name"
    values = ["blue-server"]
  }

}

data "aws_instance" "green_inst" {
  #instance_id = "*"
  filter {
    name   = "tag:Name"
    values = ["green-server"]
  }
}
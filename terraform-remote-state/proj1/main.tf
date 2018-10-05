terraform {
  required_version = ">= 0.11.7"
  backend "s3" {
    encrypt        = true
    region         = "ap-southeast-1"
    bucket         = "terraform-tfstates"
    key            = "proj-1/main.tfstate"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  version    = "~> 1.33.0"
  region     = "ap-southeast-1"
}

resource "aws_vpc" "internal_vpc" {
  cidr_block = "172.16.0.0/16"
  tags {
    Name = "example"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = "${aws_vpc.internal_vpc.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-southeast-1a"
  tags {
    Name = "example"
  }
}

resource "aws_instance" "proj_1_prod" {
  ami           = "ami-0f67499750e64577a"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.subnet_1.subnet_id}"
}

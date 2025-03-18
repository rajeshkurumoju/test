data "aws_subnet" "raj" {
    filter {
      name = "tag:Name"
      values = [ "raj" ]
    }
  
}

resource "aws_instance" "raj" {
    ami = "ami-05c179eced2eb9b5b"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.raj.id
    associate_public_ip_address = true
    key_name = "sss"
    tags = {
        name = "appugar"
    }
  
}
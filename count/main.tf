resource "aws_instance" "raj" {
    ami = "ami-05c179eced2eb9b5b"
    instance_type = "t2.micro"
    key_name = "sss"
    tags = {
        name = "appugar"
    }
  
}
resource "aws_s3_bucket" "raj" {
    bucket = "yfgdfuysdfg"
    
  
}

resource "aws_s3_bucket_versioning" "raj" {
    bucket = aws_s3_bucket.raj.id
    versioning_configuration {
      status = "Enabled"
    }
  
}


resource "aws_dynamodb_table" "raj" {
    name = "terraform-state-lock"
    hash_key = "LockID"
    read_capacity = 20
    write_capacity = 20

    attribute {
      name = "LockID"
      type = "S"
    }
  
}
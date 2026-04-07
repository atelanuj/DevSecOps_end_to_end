# resource "aws_s3_bucket" "my_s3_bucket"{
#     bucket = var.bucket_name


#     tags = {
#     Name = var.bucket_name
#     Enviroment = var.bucket_env
# }
# }

# resource "time_sleep" "wait_10_seconds" {
#     create_duration = "10s"
# }

# resource "aws_s3_object" "object" {
#   bucket = var.bucket_name
#   key    = var.object_key
#   source = var.object_source


#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5(var.object_source)
#   depends_on = [ aws_s3_bucket.my_s3_bucket ]
#   lifecycle {
#     precondition {
#         condition     = fileexists(var.object_source)
#         error_message = "The source file does not exist: ${var.object_source}"
#     }
#     postcondition {
#         condition     = self.etag == filemd5(var.object_source)
#         error_message = "The uploaded object does not match the source file's MD5 checksum."
#     }

#   }
# }

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-123456432"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
resource "aws_s3_bucket" "my_s3_bucket"{
    bucket = var.bucket_name

    tags = {
    Name = var.bucket_name
    Enviroment = var.bucket_env
}
}


resource "aws_s3_object" "object" {
  bucket = var.bucket_name
  key    = var.object_key
  source = var.object_source

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.object_source)
}
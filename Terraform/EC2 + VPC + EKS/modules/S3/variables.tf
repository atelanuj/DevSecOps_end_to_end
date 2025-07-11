variable "bucket_name" {
  type = string
  description = "The name of the S3 bucket where the object will be stored."
  default = "my-terraform-bucket"
}
variable "object_key" {
  type = string
  description = "The key (name) of the object in the S3 bucket."
  default = "new_object_key"
}
variable "object_source" {
  type = string
  description = "The local file path to the object that will be uploaded to S3."
  default = "None"
  
}
variable "bucket_env" {
  type = string
  description = "The environment for the S3 bucket (e.g., dev, prod)."
  default = "dev"
}
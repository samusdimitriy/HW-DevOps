terraform {
  backend "s3" {
    bucket         = "lesson-7-tf-state-523369939948"
    key            = "lesson-7/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "lesson-7-terraform-locks"
    encrypt        = true
  }
}

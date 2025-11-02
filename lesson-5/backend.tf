terraform {
  backend "s3" {
    bucket         = "tf-state-523369939948-lesson-5"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks-lesson-5"
    encrypt        = true
  }
}

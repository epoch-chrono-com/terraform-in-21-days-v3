resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "terraform-mentoring-tf-remote-state"

  tags = {
    Name = "${var.env_code}-epoch-tf-remote-state"
  }
}

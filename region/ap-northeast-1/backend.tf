terraform {
  required_version = ">= 0.12"

  backend "s3" {
    region = "ap-northeast-1"
    bucket = "{{ .Project }}-tfstate"
    key    = "{{ .Project }}/terraform.tfstate"
  }
}

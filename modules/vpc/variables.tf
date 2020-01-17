variable "availability_zone" {
  default = {
    "default.a" = "us-west-2a"
    "default.c" = "us-west-2c"

    "development" = {
      "a" = "ap-northeast-2a"
      "c" = "ap-northeast-2c"
    }

    "production" = {
      "a" = "ap-northeast-1a"
      "c" = "ap-northeast-1c"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  region  = "us-west-2"
  alias   = "example_org"
  profile = "example_org"
}

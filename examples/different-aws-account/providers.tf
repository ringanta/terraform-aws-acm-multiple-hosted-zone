provider "aws" {
  region  = "us-west-2"
  profile = "production"
  alias   = "production"
}

provider "aws" {
  alias   = "staging"
  region  = "us-west-2"
  profile = "staging"
}

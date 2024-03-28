terraform{
    required_providers {
        aws = {
            source ="hashicorp/aws"
            version ="5.41.0"
        }
    }
backend "s3" {
    bucket = "tf-bucket-2824"
    key = "terraform.tfstate"
    dynamodb_table = "tf_vpc_table"
    region = "us-east-1"
  
}

}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
terraform { 
    backend "s3" {
        bucket = "terraform-backend-bucket-statefile-backup"
        key    =  "vpc/terraform.tfstate"
        region = "ap-south-1"
    }
}

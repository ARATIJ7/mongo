variable "aws_access_key_id_west" {
  description = "AWS Access Key ID for West region"
}

variable "aws_secret_access_key_west" {
  description = "AWS Secret Access Key for West region"
}

variable "ami_id_west" {
  description = "AMI ID for the instances in the West region"
}

variable "instance_type" {
  description = "Instance type for MongoDB nodes"
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

variable "ssh_public_key" {
  description = "SSH public key"
}

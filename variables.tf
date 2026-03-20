variable "my_key" {
    description = "The name of the key pair to use for the EC2 instance"
    type        = string
}
variable "my_region" {
    description = "The AWS region to deploy the resources in"
    type        = string
}
variable "my_IP" {
    description = "The IP address to SSH from"
    type        = string     
}
variable "VPC_Cidr_Block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "13.21.0.0/16"
}
variable "Private_Subnet_1_Cidr_Block" {
    description = "The CIDR block for the first private subnet"
    type        = string
    default     = "13.21.1.0/24"
}
variable "Private_Subnet_2_Cidr_Block" {
    description = "The CIDR block for the second private subnet"
    type        = string
    default     = "13.21.2.0/24"
}
variable "Public_Subnet_1_Cidr_Block" {
    description = "The CIDR block for the first public subnet"
    type        = string
    default     = "13.21.3.0/24"
}
variable "Public_Subnet_2_Cidr_Block" {
    description = "The CIDR block for the second public subnet"
    type        = string
    default     = "13.21.4.0/24"
}


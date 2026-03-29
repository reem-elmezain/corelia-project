variable "user_service_image" {
  default = "184670914639.dkr.ecr.eu-central-1.amazonaws.com/user-service:latest"
}

variable "order_service_image" {
  default = "184670914639.dkr.ecr.eu-central-1.amazonaws.com/order-service:latest"
}

variable "payment_service_image" {
  default = "184670914639.dkr.ecr.eu-central-1.amazonaws.com/payment-service:latest"
}

variable "project_name" {
  default = "corelia"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "ecs_cpu" {
  default = 256
}

variable "ecs_memory" {
  default = 512
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  default = "db.t3.micro"
}
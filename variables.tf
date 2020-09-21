# General
variable "owner" {
  description = "Person Deploying this Stack e.g. john-doe"
}

variable "namespace" {
  description = "Name of the zone e.g. demo"
}

variable "hostedZone" {
  description = "The name of the dns zone on Route 53 that will be used as the master zone "
}

# AWS

variable "createAwsDnsZone" {
  description = "Set to true if you want to deploy the AWS delegated zone."
  type        = bool
}

variable "awsRegion" {
  description = "The region to create resources."
  default     = "eu-west-2"
}

# Azure

variable "createAzureDnsZone" {
  description = "Set to true if you want to deploy the Azure delegated zone."
  type        = bool
}

variable "azureLocation" {
  description = "The azure location to deploy the DNS service"
  default     = "West Europe"
}

# GCP

variable "createGcpDnsZone" {
  description = "Set to true if you want to deploy the Azure delegated zone."
  type        = bool
}

variable "gcpProject" {
  description = "GCP project name"
}

## code from and credence to @lhaig
#
## This mod has been changed as the base hosted domain (now hashicorpea.io) is hosted in another AWS account
## so the subdomains aws/gcp/azure.hashicorpea.io are ready for further subdomaining from this
#
# data "aws_route53_zone" "main" {
#   name = var.hostedZone
# }
data "aws_route53_zone" "aws" {
  name = "aws.${var.hostedZone}"
}
data "aws_route53_zone" "azure" {
  name = "azure.${var.hostedZone}"
}
data "aws_route53_zone" "gcp" {
  name = "gcp.${var.hostedZone}"
}

## SUBDOMAINS
#
## AWS R53 subdomain
#
resource "aws_route53_zone" "awsSubdomain" {
  count   = var.createAwsDnsZone ? 1 : 0
  name    = "${var.namespace}.aws.${var.hostedZone}"
  comment = "Managed by Terraform, Delegated Sub Zone for AWS for ${var.namespace}"

  tags = {
    name  = var.namespace
    owner = var.owner
  }
}

resource "aws_route53_record" "awsSubdomainNS" {
  count   = var.createAwsDnsZone ? 1 : 0
  zone_id = data.aws_route53_zone.aws.zone_id
  name    = "${var.namespace}.aws.${var.hostedZone}"
  type    = "NS"
  ttl     = "30"

  records = [
    for awsns in aws_route53_zone.awsSubdomain.0.name_servers :
    awsns
  ]
}

## Azure R53 subdomain
#
resource "aws_route53_zone" "azureSubdomain" {
  count   = var.createAzureDnsZone ? 1 : 0
  name    = "${var.namespace}.azure.${var.hostedZone}"
  comment = "Managed by Terraform, Delegated Sub Zone for Azure for ${var.namespace}"

  tags = {
    name  = var.namespace
    owner = var.owner
  }
}

resource "aws_route53_record" "azureSubdomainNS" {
  count   = var.createAzureDnsZone ? 1 : 0
  zone_id = data.aws_route53_zone.azure.zone_id
  name    = "${var.namespace}.azure.${var.hostedZone}"
  type    = "NS"
  ttl     = "30"

  records = [
    for azurens in azurerm_dns_zone.azureSubdomain.0.name_servers :
    azurens
  ]
}

## GCP R53 subdomain
#
resource "aws_route53_zone" "gcpSubdomain" {
  count         = var.createGcpDnsZone ? 1 : 0
  name          = "${var.namespace}.gcp.${var.hostedZone}"
  comment       = "Managed by Terraform, Delegated Sub Zone for GCP for  ${var.namespace}"
  force_destroy = false
  tags = {
    name  = var.namespace
    owner = var.owner
  }
}

resource "aws_route53_record" "gcpSubdomainNS" {
  count   = var.createGcpDnsZone ? 1 : 0
  zone_id = data.aws_route53_zone.gcp.zone_id
  name    = "${var.namespace}.gcp.${var.hostedZone}"
  type    = "NS"
  ttl     = "30"

  records = [
    for gcpns in google_dns_managed_zone.gcpSubdomain.0.name_servers :
    gcpns
  ]
}

## NON-AWS SUBDOMAIN RESOURCES
#
## Azure Delegated Subdomain
#
resource "azurerm_resource_group" "rg" {
  count    = var.createAzureDnsZone ? 1 : 0
  name     = "${var.namespace}DNSrg"
  location = var.azureLocation
}

resource "azurerm_dns_zone" "azureSubdomain" {
  count               = var.createAzureDnsZone ? 1 : 0
  name                = "${var.namespace}.azure.${var.hostedZone}"
  resource_group_name = azurerm_resource_group.rg.0.name
  tags = {
    name  = var.namespace
    owner = var.owner
  }
}

## GCP Delegated Subdomain
## code from and credence to @lhaig
## modified my ml4
#
resource "google_dns_managed_zone" "gcpSubdomain" {
  count       = var.createGcpDnsZone ? 1 : 0
  name        = "${var.namespace}-zone"
  dns_name    = "${var.namespace}.gcp.${var.hostedZone}."
  project     = var.gcpProject
  description = "Managed by Terraform, Delegated Sub Zone for GCP for  ${var.namespace}"
  labels = {
    name  = var.namespace
    owner = var.owner
  }
}


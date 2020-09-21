## outputs.tf child module terraform configuration
## Nomenclature: <d>-<e>-<f>-<g>[-<h>]
## where
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
## AWS specific
#
output "arz-arz-awsSubdomain-name" {
  value = aws_route53_zone.awsSubdomain[*].name
}

output "arz-arz-azureSubdomain-name" {
  value = aws_route53_zone.awsSubdomain[*].name
}

output "arz-arz-gcpSubdomain-name" {
  value = aws_route53_zone.awsSubdomain[*].name
}

## Azure specific
#
output "adz-arg-rg-name" {
  value = azurerm_resource_group.rg[*].name
}

output "adz-adz-azureSubdomain-id" {
  value = azurerm_dns_zone.azureSubdomain[*].id
}

output "adz-adz-azureSubdomain-name_servers" {
  value = azurerm_dns_zone.azureSubdomain.0.name_servers
}


## GCP specific
#
output "gdmz-gdmz-gcpSubdomain-name" {
  value = google_dns_managed_zone.gcpSubdomain[*].name
}

output "gdmz-gdmz-gcpSubdomain-name_servers" {
  value = google_dns_managed_zone.gcpSubdomain.0.name_servers
}


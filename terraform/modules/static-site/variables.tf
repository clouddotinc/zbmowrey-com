variable "app" {
  description = "A kebab-case application name"
  type = string
}
variable "owner" {
  description = "Business Unit or Team responsible for this application."
  type = string
}
variable "stage" {
  description = "develop, main, staging, qa, test, etc."
  type = string
}
variable "base-domain" {
  description = "base-domain.tld - non-prod stages will create subdomains from this."
  type = string
}

# If stage is 'main' the certificate must cover base-domain.
# If stage is not 'main', the certificate must cover $stage.base-domain.
# It's easiest (but not a requirement) to provide a wildcard certificate.

variable "acm-certificate-arn" {
  description = "ACM Certificate ARN in us-east-1, 'Issued' status, covering base-domain or $stage.base-domain. See variables.tf."
  type = string
}
variable "kms-key-arn" {
  description = "ARN of a KMS Key to be used for encrypt-decrypt of S3 Bucket Contents."
  type = string
}
resource "scalr_provider_configuration" "scalr_managed" {
  name                   = var.configuration_name
  account_id             = var.scalr_account_id
  export_shell_variables = false

  # Use role delegation as the configuration for AWS
  aws {
    credentials_type    = "role_delegation"
    account_type        = "regular"
    trusted_entity_type = "aws_account"

    role_arn = aws_iam_role.scalr_aws_integration.arn
    external_id = local.external_id
  }
  # Share the provider configuration with the dev environment
  environments = [data.scalr_environment.dev.id]
}

# Enable the provider configuration in the dev workspace.
resource "scalr_workspace" "dev_vpc_prod" {
  name = "dev_vpc_prod"
  environment_id = data.scalr_environment.dev.id
  provider_configuration {
id = scalr_provider_configuration.scalr_managed.id
  }
}

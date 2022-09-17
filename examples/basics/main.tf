terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}

variable "ibmcloud_api_key" {
  type = string
}

variable "region" {
  type        = string
  default     = "us-south"
  description = "Region where to deploy the example"
}

variable "secrets_manager_endpoint" {
  type        = string
  description = "Endpoint URL of the Secrets Manager instance"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

data "ibm_iam_auth_token" "tokendata" {}

module "my_secret_group" {
  source = "../../"

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_group = {
    name        = "my-secret-group"
    description = "my-secret-group-description"
  }
}

module "my_arbitrary_secret" {
  source = "../../"

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_arbitrary = {
    name            = "my-arbitrary-secret"
    description     = "my-secret-description"
    secret_group_id = module.my_secret_group.id
    labels          = ["a_label"]
    custom_metadata = {
      custom_value = "123456789"
    }
    version_custom_metadata = {
      custom_value = "123456789"
    }
    expiration_date = "2030-04-01T09:30:00Z"
    payload         = "my-secret-key-api"
  }
}

module "my_username_password_secret" {
  source = "../../"

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_username_password = {
    name            = "my-username_password-secret"
    description     = "my-secret-description"
    secret_group_id = module.my_secret_group.id
    labels          = ["a_label"]
    custom_metadata = {
      custom_value = "123456789"
    }
    version_custom_metadata = {
      custom_value = "123456789"
    }

    username = "admin"
    password = "password"
    expiration_date = "2030-04-01T09:30:00Z"
  }
}

resource "ibm_iam_service_id" "my_iam_credentials_secret" {
  name        = "my_iam_credentials_secret_id"
}

module "my_iam_credentials_secret" {
  source = "../../"

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_iam_credentials = {
    name            = "my-iam_credentials-secret"
    description     = "my-secret-description"
    secret_group_id = module.my_secret_group.id
    labels          = ["a_label"]
    custom_metadata = {
      custom_value = "123456789"
    }
    version_custom_metadata = {
      custom_value = "123456789"
    }

    ttl           = "24h"
    access_groups = []
    service_id    = ibm_iam_service_id.my_iam_credentials_secret.id
    reuse_api_key = true
  }
}

resource "tls_private_key" "my_imported_cert_secret" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "my_imported_cert_secret" {
  private_key_pem = tls_private_key.my_imported_cert_secret.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 2400

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

module "my_imported_cert_secret" {
  source = "../../"

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_imported_cert = {
    name            = "my-imported_cert-secret"
    description     = "my-secret-description"
    secret_group_id = module.my_secret_group.id
    labels          = ["a_label"]
    custom_metadata = {
      custom_value = "123456789"
    }
    version_custom_metadata = {
      custom_value = "123456789"
    }

    certificate = tls_self_signed_cert.my_imported_cert_secret.cert_pem
    private_key = tls_private_key.my_imported_cert_secret.private_key_pem
    intermediate = null
  }
}

module "my_kv_secret" {
  source = "../.."

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_kv = {
    name                    = "my-kv-secret"
    description             = "my-secret-description"
    secret_group_id         = module.my_secret_group.id
    labels                  = ["a_label"]
    custom_metadata = {
      custom_value = "123456789"
    }
    version_custom_metadata = {
      custom_value = "123456789"
    }
    
    payload                 = {
      apikey = "12345678"
    }
  }
}

output "resources" {
  value = [
    module.my_secret_group.id,
    module.my_arbitrary_secret.id,
    module.my_username_password_secret.id,
    module.my_iam_credentials_secret.id,
    module.my_imported_cert_secret.id,
    module.my_kv_secret.id,
  ]
}

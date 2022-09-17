variable "iam_token" {}
variable "endpoint" {}

provider "restapi" {
  uri                  = var.endpoint
  debug                = true
  write_returns_object = true
  headers = {
    Authorization = var.iam_token
  }
}

variable "resource_secret_group" {
  type = object({
    name = string
    description = string
  })
  default = null
}

variable "resource_secret_arbitrary" {
  type = object({
    name = string
    description = string
    secret_group_id = string
    labels          = list(string)
    custom_metadata = any
    version_custom_metadata = any
    expiration_date = string
    payload = string
  })
  default = null
}

variable "resource_secret_username_password" {
  type = object({
    name = string
    description = string
    secret_group_id = string
    labels          = list(string)
    custom_metadata = any
    version_custom_metadata = any
    username = string
    password = string
    expiration_date = string
  })
  default = null
}

variable "resource_secret_iam_credentials" {
  type = object({
    name = string
    description = string
    secret_group_id = string
    labels          = list(string)
    custom_metadata = any
    version_custom_metadata = any
    ttl = string
    access_groups = list(string)
    service_id = string
    reuse_api_key = bool
  })
  default = null
}

variable "resource_secret_imported_cert" {
  type = object({
    name = string
    description = string
    secret_group_id = string
    labels          = list(string)
    custom_metadata = any
    version_custom_metadata = any
    certificate = string
    private_key = string
    intermediate = string
  })
  default = null
}

variable "resource_secret_public_cert" {
  type = object({
    name = string
    description = string
    secret_group_id = string
    labels          = list(string)
    custom_metadata = any
    version_custom_metadata = any
    bundle_certs = bool
    ca = string
    dns = string
    key_algorithm = string
    alt_names = any // list(string) or string
    common_name = string
    rotation = object({
      auto_rotate = bool
      rotate_keys = bool
      interval = number
      unit = string
    })
  })
  default = null
}

variable "resource_secret_private_cert" {
  type = object({
    name = string
    description             = string
    secret_group_id         = string
    labels                  = list(string)
    custom_metadata         = any
    version_custom_metadata = any
    alt_names               = any // list(string) or string
    ip_sans                 = string
    uri_sans                = string
    other_sans              = list(string)
    ttl                     = string
    format                  = string
    private_key_format      = string
    exclude_cn_from_sans    = bool
    rotation                = object({
      auto_rotate = bool
      rotate_keys = bool
      interval = number
      unit = string
    })
  })
  default = null
}

//kv
variable "resource_secret_kv" {
  type = object({
    name                    = string
    description             = string
    secret_group_id         = string
    labels                  = list(string)
    custom_metadata         = any
    version_custom_metadata = any
    payload                 = any
  })
  default = null
}

locals {
  resource = try(element([ for resource in [
    var.resource_secret_group,
    var.resource_secret_arbitrary,
    var.resource_secret_username_password,
    var.resource_secret_iam_credentials,
    var.resource_secret_imported_cert,
    var.resource_secret_private_cert,
    var.resource_secret_public_cert,
    var.resource_secret_kv,
  ]: resource if resource != null ], 0), null)

  resource_path = (
    var.resource_secret_group != null ? "secret_groups" : (
    var.resource_secret_arbitrary != null ? "secrets/arbitrary" : (
    var.resource_secret_username_password != null ? "secrets/username_password" : (
    var.resource_secret_iam_credentials != null ? "secrets/iam_credentials" : (
    var.resource_secret_imported_cert != null ? "secrets/imported_cert" : (
    var.resource_secret_private_cert != null ? "secrets/private_cert" : (
    var.resource_secret_public_cert != null ? "secrets/public_cert" : (
    var.resource_secret_kv != null ? "secrets/kv" : (
    null
    )))))))))

  resource_type = (
    var.resource_secret_group != null ? "secret.group" : (
    var.resource_secret_arbitrary != null ? "secret" : (
    var.resource_secret_username_password != null ? "secret" : (
    var.resource_secret_iam_credentials != null ? "secret" : (
    var.resource_secret_imported_cert != null ? "secret" : (
    var.resource_secret_private_cert != null ? "secret" : (
    var.resource_secret_public_cert != null ? "secret" : (
    var.resource_secret_kv != null ? "secret" : (
    null
    )))))))))
}

resource "null_resource" "resource_change" {
  count = (var.resource_secret_group == null ? 1 : 0)

  triggers = {
    a_change = jsonencode(local.resource)
  }
}

resource "restapi_object" "resource" {
  count = var.resource_secret_group != null ? 1 : 0

  path = "/api/v1/${local.resource_path}"

  data = jsonencode({
    metadata = {
      collection_type  = "application/vnd.ibm.secrets-manager.${local.resource_type}+json"
      collection_total = 1
    }
    resources = [ local.resource ]
  })
  id_attribute = "resources/0/id"
  debug        = true
}

resource "restapi_object" "resource_with_no_update" {
  count = var.resource_secret_group == null ? 1 : 0

  path = "/api/v1/${local.resource_path}"

  data = jsonencode({
    metadata = {
      collection_type  = "application/vnd.ibm.secrets-manager.${local.resource_type}+json"
      collection_total = 1
    }
    resources = [ local.resource ]
  })
  id_attribute = "resources/0/id"
  debug        = true

  lifecycle {
    replace_triggered_by = [
      null_resource.resource_change.0.triggers
    ]
  }
}

output "id" {
  value = (
    var.resource_secret_group != null ?
    restapi_object.resource.0.id :
    restapi_object.resource_with_no_update.0.id
  )
}

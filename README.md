# Helpers for Secrets Manager 

This module helps to create secret groups and secrets with Terraform.

To use the module, specify one of:
* `resource_secret_group`
* `resource_secret_arbitrary`
* `resource_secret_username_password`
* `resource_secret_iam_credentials`
* `resource_secret_imported_cert`
* `resource_secret_public_cert`
* `resource_secret_private_cert`
* `resource_secret_kv`

```hcl
module "my_secret_group" {
  source = "we-work-in-the-cloud/secrets-manager/ibm"

  iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  endpoint  = var.secrets_manager_endpoint

  resource_secret_group = {
    name        = "my-secret-group"
    description = "my-secret-group-description"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | >= 1.17 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | >= 1.17 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Endpoint to the Secrets Manager instance | `string` | n/a | yes |
| <a name="input_iam_token"></a> [iam\_token](#input\_iam\_token) | IAM token to make API calls to the Secrets Manager instance | `string` | n/a | yes |
| <a name="input_resource_secret_arbitrary"></a> [resource\_secret\_arbitrary](#input\_resource\_secret\_arbitrary) | Set the values for this input to create a secret of type arbitrary | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    expiration_date         = string<br>    payload                 = string<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_group"></a> [resource\_secret\_group](#input\_resource\_secret\_group) | Set the values for this input to create a secret group | <pre>object({<br>    name        = string<br>    description = string<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_iam_credentials"></a> [resource\_secret\_iam\_credentials](#input\_resource\_secret\_iam\_credentials) | Set the values for this input to create a secret of type iam\_credentials | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    ttl                     = string<br>    access_groups           = list(string)<br>    service_id              = string<br>    reuse_api_key           = bool<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_imported_cert"></a> [resource\_secret\_imported\_cert](#input\_resource\_secret\_imported\_cert) | Set the values for this input to create a secret of type imported\_cert | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    certificate             = string<br>    private_key             = string<br>    intermediate            = string<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_kv"></a> [resource\_secret\_kv](#input\_resource\_secret\_kv) | Set the values for this input to create a secret of type kv | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    payload                 = any<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_private_cert"></a> [resource\_secret\_private\_cert](#input\_resource\_secret\_private\_cert) | Set the values for this input to create a secret of type private\_cert | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    alt_names               = any // list(string) or string<br>    ip_sans                 = string<br>    uri_sans                = string<br>    other_sans              = list(string)<br>    ttl                     = string<br>    format                  = string<br>    private_key_format      = string<br>    exclude_cn_from_sans    = bool<br>    rotation = object({<br>      auto_rotate = bool<br>      rotate_keys = bool<br>      interval    = number<br>      unit        = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_public_cert"></a> [resource\_secret\_public\_cert](#input\_resource\_secret\_public\_cert) | Set the values for this input to create a secret of type public\_cert | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    bundle_certs            = bool<br>    ca                      = string<br>    dns                     = string<br>    key_algorithm           = string<br>    alt_names               = any // list(string) or string<br>    common_name             = string<br>    rotation = object({<br>      auto_rotate = bool<br>      rotate_keys = bool<br>      interval    = number<br>      unit        = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_resource_secret_username_password"></a> [resource\_secret\_username\_password](#input\_resource\_secret\_username\_password) | Set the values for this input to create a secret of type username\_password | <pre>object({<br>    name                    = string<br>    description             = string<br>    secret_group_id         = string<br>    labels                  = list(string)<br>    custom_metadata         = any<br>    version_custom_metadata = any<br>    username                = string<br>    password                = string<br>    expiration_date         = string<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the created secret group or secret |

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

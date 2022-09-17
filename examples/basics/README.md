# Example - Secret group and secrets

This example illustrates how to create a secret group and secrets

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | >= 1.40 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_my_arbitrary_secret"></a> [my\_arbitrary\_secret](#module\_my\_arbitrary\_secret) | we-work-in-the-cloud/secrets-manager/ibm | n/a |
| <a name="module_my_iam_credentials_secret"></a> [my\_iam\_credentials\_secret](#module\_my\_iam\_credentials\_secret) | we-work-in-the-cloud/secrets-manager/ibm | n/a |
| <a name="module_my_imported_cert_secret"></a> [my\_imported\_cert\_secret](#module\_my\_imported\_cert\_secret) | we-work-in-the-cloud/secrets-manager/ibm | n/a |
| <a name="module_my_kv_secret"></a> [my\_kv\_secret](#module\_my\_kv\_secret) | we-work-in-the-cloud/secrets-manager/ibm | n/a |
| <a name="module_my_secret_group"></a> [my\_secret\_group](#module\_my\_secret\_group) | we-work-in-the-cloud/secrets-manager/ibm | n/a |
| <a name="module_my_username_password_secret"></a> [my\_username\_password\_secret](#module\_my\_username\_password\_secret) | we-work-in-the-cloud/secrets-manager/ibm | n/a |

## Resources

| Name | Type |
|------|------|
| [ibm_iam_service_id.my_iam_credentials_secret](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_id) | resource |
| [tls_private_key.my_imported_cert_secret](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.my_imported_cert_secret](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [ibm_iam_auth_token.tokendata](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_auth_token) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | IBM Cloud API key with access to the Secrets Manager instance | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where to deploy the example | `string` | `"us-south"` | no |
| <a name="input_secrets_manager_endpoint"></a> [secrets\_manager\_endpoint](#input\_secrets\_manager\_endpoint) | Endpoint URL of the Secrets Manager instance | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resources"></a> [resources](#output\_resources) | IDs of the resources created in the example |

---

_Generated with `terraform-docs markdown table . --hide-empty`_

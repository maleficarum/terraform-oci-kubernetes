# tflint-ignore: terraform_unused_declarations
data "oci_identity_availability_domains" "oci_identity_availability_domains" {
  compartment_id = var.compartment_id
}
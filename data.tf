# tflint-ignore: terraform_unused_declarations
data "oci_identity_availability_domains" "oci_identity_availability_domains" {
  compartment_id = var.compartment_id
}

# tflint-ignore: terraform_unused_declarations
data "oci_containerengine_cluster_kube_config" "cluster_kube_config" {
  cluster_id = oci_containerengine_cluster.oke_cluster.id

  # Optional parameters:
  expiration    = 2592000 # Token expiration in seconds (30 days)
  token_version = "2.0.0" # Kubernetes token version
}
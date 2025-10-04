output "oci_containerengine_cluster" {
  value       = oci_containerengine_cluster.oke_cluster
  description = "The created cluster"
}

output "compartment_id" {
  value = local.compartment_id
  description = "The OKE compartment"
}
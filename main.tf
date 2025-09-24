resource "oci_identity_compartment" "oke_compartment" {
  count = var.compartment_id != "" ? 1 : 0

  compartment_id = var.compartment_id
  description    = "Compartment for OKE resources"
  name           = "oke"
}

resource "oci_containerengine_cluster" "oke_cluster" {
  #Required
  compartment_id     = local.compartment_id
  kubernetes_version = var.cluster_definition.kubernetes_version
  name               = var.cluster_definition.name
  vcn_id             = var.vcn_id

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" =  var.cluster_definition.application_name == "" ? var.application_name : var.cluster_definition.application_name
  }

  endpoint_config {
    is_public_ip_enabled = var.cluster_definition.public_endpoint
    subnet_id            = var.public_subnets[var.cluster_definition.services_subnet_index]
  }

  freeform_tags = {}

  type = var.cluster_definition.cluster_type

  options {
    add_ons {

      is_kubernetes_dashboard_enabled = var.cluster_definition.options.dashboard_enabled
      is_tiller_enabled               = var.cluster_definition.options.tiller_enabled
    }
    persistent_volume_config {
      defined_tags = {
        "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
        "Oracle-Tags.Environment" = var.environment
        "Oracle-Tags.Application" = var.cluster_definition.application_name == "" ? var.application_name : var.cluster_definition.application_name
      }
    }
    service_lb_config {
      defined_tags = {
        "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
        "Oracle-Tags.Environment" = var.environment
        "Oracle-Tags.Application" = var.cluster_definition.application_name == "" ? var.application_name : var.cluster_definition.application_name
      }
    }
    service_lb_subnet_ids = [var.public_subnets[var.cluster_definition.services_subnet_index]]
  }
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = local.compartment_id
  name           = var.cluster_definition.node_pool_name
  node_shape     = var.cluster_definition.node_pool_shape
  ssh_public_key = join("\n", var.cluster_definition.public_keys)

  node_pool_cycling_details {
    is_node_cycling_enabled = true # Enable the cycling feature for this pool
    maximum_unavailable    = "1" # Optional: Define how many nodes can be cycled at once
    maximum_surge         = "1" # Optional: Define how many extra nodes can be created during cycling
  }  

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" =  var.cluster_definition.application_name == "" ? var.application_name : var.cluster_definition.application_name
  }

  node_config_details {

    defined_tags = {
      "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
      "Oracle-Tags.Environment" = var.environment
      "Oracle-Tags.Application" =  var.cluster_definition.application_name == "" ? var.application_name : var.cluster_definition.application_name
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.oci_identity_availability_domains.availability_domains[0].name
      subnet_id           = var.private_subnets[var.cluster_definition.nodepool_subnet_index]
    }
    size    = var.cluster_definition.node_pool_size
    nsg_ids = []
  }

  node_shape_config {
    memory_in_gbs = var.cluster_definition.shape_mem
    ocpus         = var.cluster_definition.shape_ocpu
  }
  node_metadata = {
    shape_version = "v2-4ocpu" # <-- Change this value when you change the shape
  }

  node_source_details {
    source_type = "IMAGE"
    image_id    = var.cluster_definition.image
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "local_file" "local_file" {
  count           = fileexists("~/.kube/config.${oci_containerengine_cluster.oke_cluster.name}") ? 0 : 1
  content         = data.oci_containerengine_cluster_kube_config.cluster_kube_config.content
  filename        = pathexpand("~/.kube/config.${oci_containerengine_cluster.oke_cluster.name}")
  file_permission = "0700"
}

resource "null_resource" "file_cleanup" {
  triggers = {
    # Capture the cluster name during creation
    cluster_name = oci_containerengine_cluster.oke_cluster.name
    config_path  = "~/.kube/config.${oci_containerengine_cluster.oke_cluster.name}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.triggers.config_path}"
  }
}
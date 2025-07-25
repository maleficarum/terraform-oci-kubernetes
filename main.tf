resource "oci_identity_compartment" "oke_compartment" {
  compartment_id = var.compartment_id
  description    = "Compartment for OKE resources"
  name           = "oke"
}

resource "oci_containerengine_cluster" "oke_cluster" {
  #Required
  compartment_id     = oci_identity_compartment.oke_compartment.id
  kubernetes_version = var.cluster_definition.kubernetes_version
  name               = var.cluster_definition.name
  vcn_id             = var.vcn_id

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" = var.application_name
  }

  endpoint_config {
    is_public_ip_enabled = var.cluster_definition.public_endpoint
    subnet_id            = var.public_subnet_id
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
        "Oracle-Tags.Application" = var.application_name
      }
    }
    service_lb_config {
      defined_tags = {
        "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
        "Oracle-Tags.Environment" = var.environment
        "Oracle-Tags.Application" = var.application_name
      }
    }
    service_lb_subnet_ids = [var.public_subnet_id]
  }
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = oci_identity_compartment.oke_compartment.id
  name           = var.cluster_definition.node_pool_name
  node_shape     = var.cluster_definition.node_pool_shape
  ssh_public_key = join("\n", var.cluster_definition.public_keys)

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" = var.application_name
  }

  node_config_details {
    defined_tags = {
      "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
      "Oracle-Tags.Environment" = var.environment
      "Oracle-Tags.Application" = var.application_name
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.oci_identity_availability_domains.availability_domains[0].name
      subnet_id           = var.private_subnet_id # Worker node subnet
    }
    size    = var.cluster_definition.node_pool_size
    nsg_ids = []
  }

  node_shape_config {
    memory_in_gbs = var.cluster_definition.shape_mem
    ocpus         = var.cluster_definition.shape_ocpu

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

resource "local_file" "kubeconfig" {
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
resource "oci_containerengine_cluster" "oke_cluster" {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = var.cluster_definition.kubernetes_version
  name               = var.cluster_definition.name
  vcn_id             = var.vcn_id

  defined_tags = {}

  endpoint_config {
    is_public_ip_enabled = var.cluster_definition.public_endpoint
    subnet_id            = var.public_subnet_id
  }

  freeform_tags = {}

  type = var.cluster_definition.cluster_type
  /*
    options {

        #Optional
        add_ons {

            #Optional
            is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
            is_tiller_enabled = var.cluster_options_add_ons_is_tiller_enabled
        }
        admission_controller_options {

            #Optional
            is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
        }
        ip_families = var.cluster_options_ip_families
        kubernetes_network_config {

            #Optional
            pods_cidr = var.cluster_options_kubernetes_network_config_pods_cidr
            services_cidr = var.cluster_options_kubernetes_network_config_services_cidr
        }
        open_id_connect_token_authentication_config {
            #Required
            is_open_id_connect_auth_enabled = var.cluster_options_open_id_connect_token_authentication_config_is_open_id_connect_auth_enabled

            #Optional
            ca_certificate = var.cluster_options_open_id_connect_token_authentication_config_ca_certificate
            client_id = oci_containerengine_client.test_client.id
            configuration_file = var.cluster_options_open_id_connect_token_authentication_config_configuration_file
            groups_claim = var.cluster_options_open_id_connect_token_authentication_config_groups_claim
            groups_prefix = var.cluster_options_open_id_connect_token_authentication_config_groups_prefix
            issuer_url = var.cluster_options_open_id_connect_token_authentication_config_issuer_url
            required_claims {

                #Optional
                key = var.cluster_options_open_id_connect_token_authentication_config_required_claims_key
                value = var.cluster_options_open_id_connect_token_authentication_config_required_claims_value
            }
            signing_algorithms = var.cluster_options_open_id_connect_token_authentication_config_signing_algorithms
            username_claim = var.cluster_options_open_id_connect_token_authentication_config_username_claim
            username_prefix = var.cluster_options_open_id_connect_token_authentication_config_username_prefix
        }                   
        open_id_connect_discovery {

            #Optional
            is_open_id_connect_discovery_enabled = var.cluster_options_open_id_connect_discovery_is_open_id_connect_discovery_enabled
        }
        persistent_volume_config {

            #Optional
            defined_tags = {"Operations.CostCenter"= "42"}
            freeform_tags = {"Department"= "Finance"}
        }
        service_lb_config {

            #Optional
            defined_tags = {"Operations.CostCenter"= "42"}
            freeform_tags = {"Department"= "Finance"}
        }
        service_lb_subnet_ids = var.cluster_options_service_lb_subnet_ids
    }*/
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = var.compartment_id
  name           = var.cluster_definition.node_pool_name
  node_shape     = var.cluster_definition.node_pool_shape

  node_config_details {
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
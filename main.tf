resource "oci_containerengine_cluster" "oke_cluster" {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = var.cluster_definition.kubernetes_version
  name               = var.cluster_definition.name
  vcn_id             = var.vcn_id

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform",
    "Oracle-Tags.Environment" = var.environment
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
        "Oracle-Tags.CreatedBy"   = "default/terraform",
        "Oracle-Tags.Environment" = var.environment
      }
    }
    service_lb_config {
      defined_tags = {
        "Oracle-Tags.CreatedBy"   = "default/terraform",
        "Oracle-Tags.Environment" = var.environment
      }
    }
    service_lb_subnet_ids = [var.public_subnet_id]
  }
  /*
    options {

        #Optional
        
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

    }*/
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = var.compartment_id
  name           = var.cluster_definition.node_pool_name
  node_shape     = var.cluster_definition.node_pool_shape
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDKf8XQ6Om71FsXzR+r61/8MfAkZW6s9BfHN49O67DyzRT6kdRxdylAamRJkD1sbQQmUeJPHnrlPP1VsFNuHe2f52fuJeCpVDHjr1hEFnLwyYRUCTnYSxdbAQlt93GyjDrh+vZ1/w9cCDf9SsBbtQejCotdya4wKwSxUOPOrnAQcXkp2n0siOnTyzqpR2pdkIZqUaHRdf02C61J3qWIfoktC7D57mhEzIABJCLghKBg/T+XdqOZOWWaDx/WDeNME1RCRguznHag2TxOm2VUJPJECw8SwGh90ZMpwsVoU9Kobj3sDGeQ0XYFEibV0WUWV7b6D6chy/H4TOQmYihTEMqI0LdZoH0eQBNiZ68ADr+dyHkQEjwIkmGDVzyGNxRNnQHYUrLwvSTp5wVL+u8vAGoWEUm5BqXyUHBwuyzdpRp8zF7zpiFyz0K25wfZfDkW3W8dNBEyItPqllLl0ut83woGIV5H1IONYyeyDc2mAo3hndAvPAqzoPZvVDubsUuNB3NZ/+jRZsxOlVxNywc71Vf3Vdx055HaXBIKnmbbxOdxUh/JUS2e+pdtuF7znMOKCo7dVFjR1gD5nHb/cmWrpT3EDyNinp3Gy4cS3Un3nT39lVw7USVKGKUuOVRcf1uujggQ2m3Ug+XxlpchVHzXbLxWxO74SQTxFb4iJ5YaiMpFw== maleficarum@misanthropia"

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform",
    "Oracle-Tags.Environment" = var.environment
  }

  node_config_details {
    defined_tags = {
      "Oracle-Tags.CreatedBy"   = "default/terraform",
      "Oracle-Tags.Environment" = var.environment
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
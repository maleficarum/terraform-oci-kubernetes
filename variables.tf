variable "compartment_id" {
  type        = string
  default     = ""
  description = "Parent compartment (OCID) where all the sub-compartments will be created (networking, compute)"
}

variable "existing_compartment" {
  type        = string
  default     = ""
  description = "The existing compartment where the network resources should be created. If this si set, the compartment_id variable should be empty"
}

variable "cluster_definition" {
  type = object({
    name               = string,
    kubernetes_version = string,
    public_endpoint    = bool,
    cluster_type       = string, #[BASIC_CLUSTER, ENHANCED_CLUSTER]
    image              = string,
    node_pools = list(object({
      node_pool_size        = number,
      node_pool_name        = string,
      node_pool_shape       = string,
      shape_mem             = number,
      shape_ocpu            = number,
      shape_version_tag     = optional(string, ""),
      public_keys           = list(string),
      nodepool_subnet_index = number,

    }))
    cni_type = string,
    options = object({
      dashboard_enabled = bool,
      tiller_enabled    = bool
    }),
    services_subnet_index   = number,
    api_server_subnet_index = number
    application_name        = string,
    freeform_tags = optional(map(string), {
      "OracleTags.CreatedBy"   = "default/terraform-cae",
      "OracleTags.Environment" = "general"
      "OracleTags.Application" = "landing-zone"
    }),
    defined_tags = optional(map(string), {})
  })
  description = "The cluster definition"
}

variable "vcn_id" {
  type        = string
  description = "The OCID of the VCN"
}

variable "public_subnets" {
  type        = list(string)
  description = "The OCID of the public subnet"
}

variable "private_subnets" {
  type        = list(string)
  description = "The OCID of the private subnet"
}

# variable "oke_workers_nsg" {
#   type        = list(string)
#   description = "The security group to be assigned to the workers"
# }

# variable "environment" {
#   type        = string
#   description = "The deployed environment"
# }

# variable "application_name" {
#   type        = string
#   default     = "General"
#   description = "The application name that will be deployed over this resource"
# }
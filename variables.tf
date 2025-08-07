variable "compartment_id" {
  type        = string
  description = "Compartment ID to deployt the resources"
}

variable "cluster_definition" {
  type = object({
    name               = string,
    kubernetes_version = string,
    public_endpoint    = bool,
    cluster_type       = string, #[BASIC_CLUSTER, ENHANCED_CLUSTER]
    node_pool_size     = number,
    node_pool_name     = string,
    node_pool_shape    = string,
    cni_type           = string,
    shape_mem          = number,
    shape_ocpu         = number,
    image              = string,
    options = object({
      dashboard_enabled = bool,
      tiller_enabled    = bool
    }),
    public_keys = list(string),
    nodepool_subnet_index = number,
    services_subnet_index = number,
    application_name = string
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

variable "environment" {
  type        = string
  description = "The deployed environment"
}

variable "application_name" {
  type        = string
  default     = "General"
  description = "The application name that will be deployed over this resource"
}
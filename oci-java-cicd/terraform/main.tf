
provider "oci" {
  region = "us-ashburn-1"
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
}





# VCN
resource "oci_core_virtual_network" "oke_vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "oke-vcn"
  dns_label      = "okevcn"
}




# Security List for Worker Nodes
resource "oci_core_security_list" "oke_worker_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-worker-sl"

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}



resource "oci_core_nat_gateway" "oke_nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-nat-gateway"
}

resource "oci_core_route_table" "oke_private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-private-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.oke_nat_gateway.id
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Subnet for OKE Worker Nodes
resource "oci_core_subnet" "oke-node-subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  cidr_block                 = "10.0.20.0/24"
  display_name               = "oke-node-subnet"
  dns_label                  = "okenodes"
  route_table_id             = oci_core_route_table.oke_private_route_table.id
  security_list_ids          = [oci_core_security_list.oke_worker_sl.id]
  prohibit_public_ip_on_vnic = true
}

resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_ocid
  name               = "oci-java-oke-cluster"
  vcn_id             = oci_core_virtual_network.oke_vcn.id
  kubernetes_version = "v1.30.1"
  
}

resource "oci_containerengine_node_pool" "oke_node_pool" {
  compartment_id      = var.compartment_ocid
  cluster_id          = oci_containerengine_cluster.oke_cluster.id
  name                = "oci-java-nodepool"
  kubernetes_version  = "v1.30.1"
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.oke-node-subnet.id
    }
    size = 2
  }
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    ocpus = 2
    memory_in_gbs = 8
  }
  node_source_details {
    source_type = "IMAGE"
    image_id    = "ocid1.image.oc1.iad.aaaaaaaa35afxc4q57i6xnd275vmtr57zjrccp3lyr26mwl4yfpx4lpb2koq"
  }
  ssh_public_key = var.ssh_public_key
}

resource "oci_artifacts_container_repository" "java_repo" {
  compartment_id = var.compartment_ocid
  display_name   = "java-svc"
  is_public      = false
}

output "cluster_id" {
  value = oci_containerengine_cluster.oke_cluster.id
}

output "node_pool_id" {
  value = oci_containerengine_node_pool.oke_node_pool.id
}

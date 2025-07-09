
output "oke_cluster_id" {
  value = oci_containerengine_cluster.oke_cluster.id
}
output "oke_node_pool_id" {
  value = oci_containerengine_node_pool.oke_node_pool.id
}
output "vcn_id" {
  value = oci_core_virtual_network.oke_vcn.id
}
output "subnet_id" {
  value = oci_core_subnet.oke-node-subnet.id
}


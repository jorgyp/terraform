terraform {
  backend "azurerm" {
    resource_group_name       = var.aks_resource_group_name
    storage_account_name      = var.storage_account_name
    container_name            = var.storage_container_name
    key                       = var.key
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" { 
  name                = var.aks_cluster_name
  resource_group_name = var.aks_resource_group_name
  location            = var.aks_location
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.aks_k8s_version
  
  linux_profile {
    admin_username    = var.aks_admin_username
    ## SSH key is generated using "tls_private_key" resource
    ssh_key {
      key_data        = "${trimspace(tls_private_key.key.public_key_openssh)} ${var.aks_admin_username}@azure.com"
    }
  }

  agent_pool_profile {
    name              = "default"
    count             = var.aks_node_count
    vm_size           = "Standard_D1_v2"
    os_type           = "Linux"
    os_disk_size_gb   = 30
  }

  service_principal {
    client_id         = var.azure_client_id
    client_secret     = var.azure_client_secret
  }

  tags = {
    Environment       = "production"
  }
}

## Private key for the kubernetes cluster ##
resource "tls_private_key" "key" {
  algorithm           = "RSA"
}

## Save the private key in the local workspace ##
resource "null_resource" "save-key" {
  triggers = {
    key               = tls_private_key.key.private_key_pem
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.root}/.ssh
      echo "${tls_private_key.key.private_key_pem}" > ${path.root}/.ssh/id_rsa-${var.aks_dns_prefix}
      chmod 0600 ${path.root}/.ssh/id_rsa-${var.aks_dns_prefix}
      mkdir -p ${path.root}/.kube
      echo "${azurerm_kubernetes_cluster.aks_cluster.kube_config_raw}" > ${path.root}/.kube/aksconfig-${var.aks_dns_prefix}
      chmod 0600 ${path.root}/.kube/aksconfig-${var.aks_dns_prefix}
EOF
  }
}

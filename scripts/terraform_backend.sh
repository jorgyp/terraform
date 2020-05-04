#!/bin/bash
RESOURCE_GROUP_NAME=$1
STORAGE_ACCOUNT_NAME=$2
CONTAINER_NAME=$3

if [[ -z $1 || -z $2 || -z $3 ]] ; then
    echo "please using the following format: terraform_backend.sh <resource_group_name> <storage_acct_name> <blob_container_name>"
    exit 1
fi

exit 1
# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westus2

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --location westus2 --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
#echo "access_key: $ACCOUNT_KEY"

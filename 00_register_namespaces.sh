# assumes az logged in and tenant selected

az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KeyVault

echo "check with:"
echo "az provider show --namespace Microsoft.ContainerService --query registrationState"
echo "check with:"
echo "az provider show --namespace Microsoft.KeyVault --query registrationState"
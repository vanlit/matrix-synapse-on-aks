sudo apt install unzip

wget https://github.com/opentofu/opentofu/releases/download/vX.Y.Z/tofu_X.Y.Z_linux_amd64.zip
unzip tofu_*.zip
sudo mv tofu /usr/local/bin/

az login

cd infra/tofu

cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars

tofu init
tofu plan
tofu apply
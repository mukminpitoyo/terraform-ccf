#!/bin/bash

# Install dependencies (git, node, yarn, jq)
yum update -y
yum install -y git
curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
yum install -y nodejs
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
yum install -y yarn
yum install -y jq
yum install -y aws-cli

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# # Verify Docker Compose installation
docker-compose --version
if [ $? -eq 0 ]; then
  echo "Docker Compose is installed successfully."
else
  echo "Docker Compose installation failed. Please check the installation script."
  exit 1
fi

# Clone CCF repository and install dependencies
su - ec2-user
cd /home/ec2-user
git clone https://github.com/mukminpitoyo/cloud-carbon-footprint.git
# git clone https://github.com/cloud-carbon-footprint/cloud-carbon-footprint.git
cd cloud-carbon-footprint/
yarn install

# # Verify yarn installation
yarn --version
if [ $? -eq 0 ]; then
  echo "yarn is installed successfully."
else
  echo "yarn installation failed. Please check the installation script."
  exit 1
fi

# Set env variables for Node API
cd packages/api
cp .env.template .env

# sed -i '23,48d' .env
# sed -i '17,18d' .env
sed -i 's/your-target-account-role-name (e.g. ccf-app)/cloud-carbon-footprint/g' .env
sed -i 's/your-athena-db-name/costandusagereportdatabase/g' .env
sed -i 's/your-athena-db-table/costandusagereport/g' .env
sed -i 's/your-athena-region/ap-southeast-1/g' .env
sed -i 's/your-athena-query-results-location/cloud-carbon-footprint-athenaqueryresultsbucket-24mjc7ujxotx/g' .env
sed -i 's/your-billing-account-id/643546341891/g' .env
sed -i 's/your-billing-account-name/AWSReservedSSO_agency_admin_501f943b6065c615/mukmin_pitoyo_from.tp@tech.gov.sg/g' .env
sed -i 's/=default/=IAM/g' .env
# sed -i 's/your-cache-mode/MONGODB/g' .env
# sed -i 's#your-mongodb-uri#mongodb+srv://ccfmongo:0000ccfmongo@ccf-mongo.baimiag.mongodb.net#g' .env

cd ../..

# Set env variables for React client
cd packages/client
cp .env.template .env

sed -i 's/REACT_APP_PREVIOUS_YEAR_OF_USAGE/#REACT_APP_PREVIOUS_YEAR_OF_USAGE/g' .env
sed -i 's/=2/=12/g' .env

cat <<EOF >> .env
PORT=80
EOF

# Start CCF application (client and API)
cd /home/ec2-user/cloud-carbon-footprint/
# # yarn start
# #  Create Docker Secrets
pwd ; yarn create-docker-secrets ; echo "=== FINISHED RUNNING yarn create-docker-secrets ==="; cd /home/ec2-user; pwd;
# cd .docker/secrets ; pwd; ls

# docker-compose up
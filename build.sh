#!/bin/bash

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Configure Linux
sysctl -w vm.max_map_count=524288
echo -n "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf

# Clone repo
mkdir -p /opt/iris && cd /opt/iris
git clone https://github.com/parabellyx/iris-infra.git
cd iris-infra
git checkout release/v0.3

# Change the password based on env vars
sed -i "s/##password##/$POSTGRES_PASSWORD/g" secrets/pgsql.secret
sed -i "s/##password##/$SONAR_JDBC_PASSWORD/g" secrets/pgsql.secret

kubectl kustomize | kubectl apply -f -

unset POSTGRES_PASSWORD SONAR_JDBC_PASSWORD

echo "sudo kubectl exec -it --namespace=appsec $(sudo kubectl get pods --namespace=appsec | awk '/jenkins/ {print $1}') -- cat /var/jenkins_home/secrets/initialAdminPassword" > /opt/iris/fetchJenkinsCred.sh
chmod +x /opt/iris/fetchJenkinsCred.sh

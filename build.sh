#!/bin/bash

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Install kustomize
# curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
# mv kustomize /usr/bin

# Configure Linux
sysctl -w vm.max_map_count=524288

# Clone repo
git clone https://github.com/parabellyx/iris-infra.git
cd iris-infra

# Change the password based on env vars
sed -i "s/##password##/$KEYCLOAK_PASSWORD/g" secrets/keycloak.secret
sed -i "s/##password##/$POSTGRES_PASSWORD/g" secrets/pgsql.secret
sed -i "s/##password##/$SONAR_JDBC_PASSWORD/g" secrets/pgsql.secret
sed -i "s/##hostname##/$HOSTNAME/g" configs/keycloak.config

kubectl kustomize | kubectl apply -f -

unset KEYCLOAK_PASSWORD POSTGRES_PASSWORD SONAR_JDBC_PASSWORD
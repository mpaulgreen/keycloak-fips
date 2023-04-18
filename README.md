# Setup FIPS with keycloak operator
```
oc get secret -n openshift-ingress  router-certs-default -o go-template='{{index .data "tls.crt"}}' | base64 -d > tls.crt
oc get secret -n openshift-ingress  router-certs-default -o go-template='{{index .data "tls.key"}}' | base64 -d > tls.key
oc -n keycloak create secret tls cluster-cert --cert=./tls.crt --key=./tls.key
./build-fips-keycloak-docker-image.sh
docker build -t quay.io/mpaulgreen/keycloak-fips-pod:21.0.2 .
docker push quay.io/mpaulgreen/keycloak-fips-pod:21.0.2
oc apply -f db-secret.yaml
oc -n keycloak new-app -e POSTGRESQL_USER=admin -e POSTGRESQL_PASSWORD=password -e POSTGRESQL_DATABASE=keycloak --image-stream="openshift/postgresql:13-el7"
oc apply -f keycloak.yaml 
```

# For quarkus app with Authorization code workflow
- https://github.com/mpaulgreen/security-openid-connect-web-authentication/blob/master/README.md
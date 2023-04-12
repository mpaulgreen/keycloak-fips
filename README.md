- Setup FIPS with keycloak operator
```
oc get secret -n openshift-ingress  router-certs-default -o go-template='{{index .data "tls.crt"}}' | base64 -d > tls.crt
oc get secret -n openshift-ingress  router-certs-default -o go-template='{{index .data "tls.key"}}' | base64 -d > tls.key
oc -n keycloak create secret tls cluster-cert --cert=./tls.crt --key=./tls.key
./build-fips-keycloak-docker-image.sh
docker build -t quay.io/mpaulgreen/keycloak-fips-pod:21.0.2 .
docker push quay.io/mpaulgreen/keycloak-fips-pod:21.0.2
oc apply -f keycloak.yaml // health probes failing
```

- Issues
https://github.com/keycloak/keycloak/issues/19654

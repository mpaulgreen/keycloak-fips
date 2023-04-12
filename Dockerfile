FROM quay.io/keycloak/keycloak:21.0.2 as builder

ADD files /tmp/files/

WORKDIR /opt/keycloak
RUN cp /tmp/files/*.jar /opt/keycloak/providers/
RUN cp /tmp/files/keycloak-fips.keystore.* /opt/keycloak/bin/
# RUN cp /tmp/files/tls.* /opt/keycloak/bin
RUN cp /tmp/files/keycloak.conf /opt/keycloak/conf/

RUN /opt/keycloak/bin/kc.sh show-config


RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:21.0.2
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
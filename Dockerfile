FROM vault:0.6.2

RUN apk add --no-cache curl
COPY load.sh /usr/local/bin/load
COPY config.hcl /vault/config/

ENV VAULT_ENTRYPOINT=/usr/local/bin/docker-entrypoint.sh
ENV VAULT_ADDR=http://127.0.0.1:8200
ENV VAULT_CONFIG=/vault/config/config.hcl
ENV CONSUL_ADDRESS=consul:8500
ENV UNSEAL_KEY=

ENTRYPOINT ["/usr/local/bin/load"]
CMD ["vault", "server", "-config", "/vault/config"]

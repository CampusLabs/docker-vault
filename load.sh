#!/bin/sh

sed -i -- "s|CONSUL_ADDRESS|$CONSUL_ADDRESS|g" $VAULT_CONFIG

until $(curl --output /dev/null --silent --head --fail http://${CONSUL_ADDRESS}/v1/health/service/consul); do
  sleep 1
done

$VAULT_ENTRYPOINT "$@" &

until $(curl --output /dev/null --silent --fail -X PUT -d "{\"key\":\"${UNSEAL_KEY}\"}" ${VAULT_ADDR}/v1/sys/unseal); do
  sleep 1
done

wait $!

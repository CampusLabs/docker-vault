#!/bin/sh

sed -i -- "s|CONSUL_ADDRESS|$CONSUL_ADDRESS|g" $VAULT_CONFIG

until $(curl --output /dev/null --silent --head --fail http://${CONSUL_ADDRESS}/v1/health/service/consul); do
  sleep 1
done

$VAULT_ENTRYPOINT "$@" &

until $(curl --output /dev/null --silent --fail -X PUT ${VAULT_ADDR}/sys/unseal?key=${UNSEAL_KEY}); do
  sleep 1
done

wait $!

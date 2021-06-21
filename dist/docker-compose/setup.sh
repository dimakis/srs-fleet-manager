#!/bin/bash

if [ -z "$1" ]
then
  echo "Please provide the neccessary arguments!"
  exit 1
fi

HOST_IP=$1
P=$(pwd)

##if the script runs in the container, we have to adjust the path to the mount point
if [ $P == "/" ]
then
  export P=/apicurio
fi

KC_ROOT_DB_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6)
KC_DB_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6)
KC_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6)
AS_SQL_ROOT_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6)
AS_DB_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6)


sed 's/$HOST/'"$HOST_IP"'/g' $P/.env.template > $P/tmp; mv $P/tmp $P/.env

sed 's/$DB_TYPE/'"postgresql9"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env
sed 's/$DB_DRIVER/'"postgresql"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env
sed 's/$DB_CONN_URL/'"jdbc:postgresql:\\/\\/apicurio-db\\/apicuriodb"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env

sed 's/$KC_ROOT_DB_PASSWORD/'"$KC_ROOT_DB_PASSWORD"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env
sed 's/$KC_DB_PASSWORD/'"$KC_DB_PASSWORD"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env
sed 's/$KC_PASSWORD/'"$KC_PASSWORD"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env
sed 's/$AS_SQL_ROOT_PASSWORD/'"$AS_SQL_ROOT_PASSWORD"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env
sed 's/$AS_DB_PASSWORD/'"$AS_DB_PASSWORD"'/g' $P/.env > $P/tmp; mv $P/tmp $P/.env

echo "Keycloak username: admin"
echo "Keycloak password: $KC_PASSWORD"
echo "Keycloak URL: $HOST_IP:8090"
echo "Registry URL: $HOST_IP:8080"
echo "Tenant Manager URL: $HOST_IP:8081"
echo "Fleet Manager URL: $HOST_IP:8082"
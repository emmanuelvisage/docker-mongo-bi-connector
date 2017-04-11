#!/bin/sh

mongoDRDLParams="--host $MONGO_HOST --port $MONGO_PORT -d $DB_NAME -o schema.drdl"
MONGO_URI="mongodb://${MONGO_HOST}:${MONGO_PORT}"
mongoSQLDParams="--addr mongo-bi-connector:3307 --schema schema.drdl --mongo-uri $MONGO_URI"
if [ -n "$MONGO_USERNAME" ] && [ -n "$MONGO_PASSWORD" ]  && [ -n "$MONGO_AUTH_DB" ]  && [ -n "$SSL_STRING" ]; then
    if [ ! -f ./bi_connector_auto_signed.pem ]; then
        openssl req -nodes -newkey rsa:2048 -keyout temp.key -out temp.crt -x509 -days 365 -subj $SSL_STRING
        cat temp.crt temp.key > bi_connector_auto_signed.pem
    fi
    USER_STRING="${MONGO_USERNAME}:${MONGO_PASSWORD}@"
    MONGO_URI="mongodb://${USER_STRING}${MONGO_HOST}:${MONGO_PORT}"
    mongoDRDLParams="${mongoDRDLParams} --username ${MONGO_USERNAME} --password ${MONGO_PASSWORD} --authenticationDatabase ${MONGO_AUTH_DB} "
    mongoSQLDParams="${mongoDRDLParams} --auth --sslPEMKeyFile bi_connector_auto_signed.pem"
fi

TEMP_FILE="/tmp/mysql.sock";
rm -f $TEMP_FILE

`/usr/local/bin/mongodrdl ${mongoDRDLParams}`
`/usr/local/bin/mongosqld ${mongoSQLDParams}`

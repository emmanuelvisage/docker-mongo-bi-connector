#!/bin/sh

mongoDRDLParams="--host $MONGO_HOST --port $MONGO_PORT -d $DB_NAME -o schema.drdl"
MONGO_URI="mongodb://${MONGO_HOST}:${MONGO_PORT}"
if [ -n "$MONGO_USERNAME" ] && [ -n "$MONGO_PASSWORD" ]  && [ -n "$MONGO_AUTH_DB" ]; then
    USER_STRING="${MONGO_USERNAME}:${MONGO_PASSWORD}@"
    MONGO_URI="mongodb://${USER_STRING}${MONGO_HOST}:${MONGO_PORT}"
    mongoDRDLParams="${mongoDRDLParams} --username ${MONGO_USERNAME} --password ${MONGO_PASSWORD} --authenticationDatabase ${MONGO_AUTH_DB} "
fi

echo ${mongoDRDLParams}

`/usr/local/bin/mongodrdl ${mongoDRDLParams}`
/usr/local/bin/mongosqld --addr mongo-bi-connector:3307 --schema schema.drdl --mongo-uri $MONGO_URI


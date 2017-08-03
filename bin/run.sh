#!/bin/sh

rm -f tmpschema.drdl
schemaFile="schema.drdl"
if [ "$1" = "-e" -a input="-" ];then
    cat $input >> tmpschema.drdl
    schemaFile="tmpschema.drdl"
fi

mongoDRDLParams="--host $MONGO_HOST --port $MONGO_PORT -d $DB_NAME -o schema.drdl"
MONGO_URI="mongodb://${MONGO_HOST}:${MONGO_PORT}"
mongoSQLDParams="--addr $ADDR --schema ${schemaFile} --mongo-uri $MONGO_URI"

if [ -n "$MONGO_USERNAME" ] && [ -n "$MONGO_PASSWORD" ]  && [ -n "$MONGO_AUTH_DB" ]; then
    USER_STRING="${MONGO_USERNAME}:${MONGO_PASSWORD}@"
    MONGO_URI="mongodb://${USER_STRING}${MONGO_HOST}:${MONGO_PORT}"
    mongoDRDLParams="${mongoDRDLParams} --username ${MONGO_USERNAME} --password ${MONGO_PASSWORD} --authenticationDatabase ${MONGO_AUTH_DB} "
    mongoSQLDParams="${mongoSQLDParams} --auth"
fi

TEMP_FILE="/tmp/mysql.sock";
rm -f $TEMP_FILE

if ! [ -f "tmpschema.drdl" ]; then
    `/usr/local/bin/mongodrdl ${mongoDRDLParams}`
fi

`/usr/local/bin/mongosqld ${mongoSQLDParams}`

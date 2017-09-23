#!/bin/sh

rm -f tmpschema.drdl
if [ -n "$1" ] && [ "$1" = "-e" -a input="-" ];then
    cat $input >> tmpschema.drdl
    schemaFile="tmpschema.drdl"
fi
if [ -n "$SCHEMA_PATH" ]; then
    schemaFile=$SCHEMA_PATH
fi

if [ -z "$schemaFile" ]; then
    mongoDRDLParams="--host $MONGO_HOST --port $MONGO_PORT -d $DB_NAME -o schema.drdl"
    if [ -n "$MONGO_USERNAME" ] && [ -n "$MONGO_PASSWORD" ]  && [ -n "$MONGO_AUTH_DB" ]; then
        mongoDRDLParams="${mongoDRDLParams} --username ${MONGO_USERNAME} --password ${MONGO_PASSWORD} --authenticationDatabase ${MONGO_AUTH_DB} "
    fi
    `/usr/local/bin/mongodrdl ${mongoDRDLParams}`
    schemaFile="schema.drdl"
fi

if [ -n "$MONGO_HOST" ] && [ -n "$MONGO_PORT" ]; then
    MONGO_URI="mongodb://${USER_STRING}${MONGO_HOST}:${MONGO_PORT}"
fi

echo $MONGO_URI


mongoSQLDParams="--addr $ADDR --schema ${schemaFile} --mongo-uri $MONGO_URI"

if [ -n "$MONGO_AUTH" ]; then
    mongoSQLDParams="${mongoSQLDParams} --auth"
fi

if [ -n "$MONGO_SSL" ]; then
    mongoSQLDParams="${mongoSQLDParams} --mongo-ssl"
fi


echo $mongoSQLDParams

TEMP_FILE="/tmp/mysql.sock";
rm -f $TEMP_FILE


`/usr/local/bin/mongosqld ${mongoSQLDParams}`

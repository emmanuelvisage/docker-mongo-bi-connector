#!/bin/sh

USER_STRING=""
if [ -n "$MONGO_USERNAME" ] && [ -n "$MONGO_PASSWORD" ]; then
    USER_STRING="${MONGO_USERNAME}:${MONGO_PASSWORD}@"
fi

/usr/local/bin/mongodrdl --host $MONGO_HOST --port $MONGO_PORT -d $DB_NAME -o schema.drdl
/usr/local/bin/mongosqld --schema schema.drdl --mongo-uri mongodb://${USER_STRING}${MONGO_HOST}:${MONGO_PORT}


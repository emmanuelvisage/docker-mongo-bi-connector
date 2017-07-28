#!/bin/bash

wait-for-it.sh -t 0 $MONGO_HOST:$MONGO_PORT -- cat $SCHEMA_PATH | run.sh -e
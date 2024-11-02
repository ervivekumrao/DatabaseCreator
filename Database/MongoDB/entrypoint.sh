#!/usr/bin/env bash

echo "db.$MONGO_INITDB_SCHEMA.insertOne({test : { source: 1, cost: 1, part_number:1 } })"  | mongosh "mongodb://$MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD@localhost:27017/$MONGO_INITDB_DATABASE?authSource=admin"
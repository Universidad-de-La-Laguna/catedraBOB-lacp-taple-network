#!/bin/bash

# Sustitucion de variables
export MASTER_ID=`cat .credentials.master | sed -n 's/^MASTER_ID: \(.*\)$/\1/p'`
export SLAVE1_ID=`cat .credentials.slave1 | sed -n 's/^SLAVE_ID: \(.*\)$/\1/p'`
export SLAVE2_ID=`cat .credentials.slave2 | sed -n 's/^SLAVE_ID: \(.*\)$/\1/p'`
envsubst < lacp-gobernance.json.tmpl > temp-lacp-gobernance.json

# Creacion de la gobernanza
curl --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY;' \
--header 'Content-Type: application/json' \
--data @temp-lacp-gobernance.json
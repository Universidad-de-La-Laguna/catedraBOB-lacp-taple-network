#!/bin/bash

# Comprobar prerequisitos
if ! command -v jq &> /dev/null
then
    echo "jq could not be found"
    exit
fi

# Sustitucion de variables
export NODEADMIN_CONTROLLER_ID=`cat .credentials.nodeadmin | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`
export NODEREGIS_CONTROLLER_ID=`cat .credentials.noderegis | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`
export NODEPRESI_CONTROLLER_ID=`cat .credentials.nodepresi | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`
envsubst < templates/lacp-gobernance.json.tmpl > temp-lacp-gobernance.json

# Creacion de la gobernanza
CREATE_GOBERNANCE_RESULT=`curl -s --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY;' \
--header 'Content-Type: application/json' \
--data @temp-lacp-gobernance.json`

GOBERNANCE_SUBJECT_ID=`jq -r .subject_id <<< $CREATE_GOBERNANCE_RESULT`

echo "Gobernanza creada correctamente con subject_id: $GOBERNANCE_SUBJECT_ID"

echo -n $GOBERNANCE_SUBJECT_ID > .gobernance_subject_id
#!/bin/bash

# En este caso el Administrador hace un cambio del sujeto
# La política indica que si el que el cambio lo realiza el propietario, se debe aprobar el cambio
# La aprobación del cambio la hace el nodo del presidente. 

export RECORD_ID=`cat .record_id`

envsubst < templates/modify-record.json.tmpl > temp-modify-record-by-owner.json

MODIFY_RECORD_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-record-by-owner.json`

echo $MODIFY_RECORD_REQUEST | jq

MODIFY_RECORD_REQUEST_ID=`jq -r .request_id <<< $MODIFY_RECORD_REQUEST`

echo -n $MODIFY_RECORD_REQUEST_ID > .modify_record_request_id
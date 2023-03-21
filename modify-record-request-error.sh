#!/bin/bash

# En este caso el Secretario hace un cambio del sujeto
# La política indica que si el que el cambio lo realiza el propietario, se debe aprobar el cambio
# La aprobación del cambio la hace el nodo del presidente. 

export RECORD_SUBJECT_ID=`cat .record_id`
export LACP_SUBJECT_ID=`cat .lacp_id`

envsubst < templates/modify-record.json.tmpl > temp-modify-record-by-owner.json

echo "El presidente intenta modificar un acta..."

MODIFY_RECORD_REQUEST=`curl --silent --location --request POST 'http://localhost:3002/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-record-by-owner.json`

echo $MODIFY_RECORD_REQUEST

echo "El registrador intenta modificar un acta..."

MODIFY_RECORD_REQUEST=`curl --silent --location --request POST 'http://localhost:3001/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-record-by-owner.json`

echo $MODIFY_RECORD_REQUEST

echo "El secretario intenta modificar un acta..."

MODIFY_RECORD_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-record-by-owner.json`

echo $MODIFY_RECORD_REQUEST | jq
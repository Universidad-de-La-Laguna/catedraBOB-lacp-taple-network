#!/bin/bash

export GOVERNANCE_SUBJECT_ID=`cat .governance_subject_id`
export LACP_SUBJECT_ID=`cat .lacp_id`

envsubst < templates/create-record.json.tmpl > temp-create-record.json

CREATE_RECORD_RESULT=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-create-record.json`

RECORD_ID=`jq -r .subject_id <<< $CREATE_RECORD_RESULT`

echo "Acta creado correctamente con subject_id: $RECORD_ID"

echo $CREATE_RECORD_RESULT | jq

echo -n $RECORD_ID > .record_id
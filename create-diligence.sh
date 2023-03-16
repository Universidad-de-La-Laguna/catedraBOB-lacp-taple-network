#!/bin/bash

export GOBERNANCE_SUBJECT_ID=`cat .gobernance_subject_id`

envsubst < templates/create-diligence.json.tmpl > temp-create-diligence.json

CREATE_DILIGENCE_RESULT=`curl --silent --location --request POST 'http://localhost:3001/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-create-diligence.json`

DILIGENCE_ID=`jq -r .subject_id <<< $CREATE_DILIGENCE_RESULT`

echo "Diligencia creado correctamente con subject_id: $DILIGENCE_ID"

echo $CREATE_DILIGENCE_RESULT | jq

echo -n $DILIGENCE_ID > .diligence_id
#!/bin/bash

export GOVERNANCE_SUBJECT_ID=`cat .governance_subject_id`

#envsubst < templates/create-lacp.json.tmpl > temp-create-lacp.json

CREATE_LACP_RESULT=`curl --silent --location --request GET 'http://localhost:3000/api/subjects' \
#--header 'X-API-KEY: 1234' \
#--header 'Content-Type: application/json' \
#--data @temp-create-lacp.json`

#LACP_ID=`jq -r .subject_id <<< $CREATE_LACP_RESULT`

#echo "LACP creado correctamente con subject_id: $LACP_ID"

echo $CREATE_LACP_RESULT | jq

#echo -n $LACP_ID > .lacp_id
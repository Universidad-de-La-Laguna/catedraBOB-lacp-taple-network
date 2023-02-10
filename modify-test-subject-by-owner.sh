#!/bin/bash

export TEST_SUBJECT_ID=`cat .test_subject_id`
export TEST_SUBJECT_LOCATION="London"

envsubst < templates/modify-test-subject.json.tmpl > temp-modify-test-subject-by-owner.json

MODIFY_TEST_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-test-subject-by-owner.json`

echo $MODIFY_TEST_SUBJECT_REQUEST | jq

MODIFY_TEST_SUBJECT_REQUEST_ID=`jq -r .request_id <<< $MODIFY_TEST_SUBJECT_REQUEST`

echo "Aprobando la petición con request_id $MODIFY_TEST_SUBJECT_REQUEST_ID"

APPROVAL=`curl --silent --location --request PUT "http://localhost:3002/api/approvals/$MODIFY_TEST_SUBJECT_REQUEST_ID" \
--header 'Content-Type: application/json' \
--data-raw '{
    "approvalType": "Accept"
}'`

echo "Peticion aprobada y subject modificado"
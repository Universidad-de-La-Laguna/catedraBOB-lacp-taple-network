#!/bin/bash

export TEST_SUBJECT_ID=`cat .test_subject_id`
export TEST_SUBJECT_LOCATION="London2"

envsubst < modify-test-subject.json.tmpl > temp-modify-test-subject-by-other.json

# Fijarse que la petición la hace el slave1 (no propietario)
MODIFY_TEST_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3001/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-test-subject-by-other.json`

echo $MODIFY_TEST_SUBJECT_REQUEST | jq

# MODIFY_TEST_SUBJECT_REQUEST_ID=`jq -r .request_id <<< $MODIFY_TEST_SUBJECT_REQUEST`

# echo "Solicitud de modificacion con request_id: $MODIFY_TEST_SUBJECT_REQUEST_ID"

# curl --silent --location --request PUT "http://localhost:3000/api/approvals/$MODIFY_TEST_SUBJECT_REQUEST_ID" \
# --header 'X-API-KEY: 1234' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "approvalType": "Accept"
# }'
#!/bin/bash

export GOBERNANCE_SUBJECT_ID=`cat .gobernance_subject_id`
export TEST_SUBJECT_LOCATION="Spain"

envsubst < templates/create-test-subject.json.tmpl > temp-create-test-subject.json

TEST_SUBJECT=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-create-test-subject.json`

TEST_SUBJECT_ID=`jq -r .subject_id <<< $TEST_SUBJECT`

echo "Test subject creado correctamente con subject_id: $TEST_SUBJECT_ID"

echo $TEST_SUBJECT | jq

echo -n $TEST_SUBJECT_ID > .test_subject_id
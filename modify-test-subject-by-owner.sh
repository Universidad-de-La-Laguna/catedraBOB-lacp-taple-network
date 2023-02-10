#!/bin/bash

export TEST_SUBJECT_ID=`cat .test_subject_id`
export TEST_SUBJECT_LOCATION="London"

envsubst < templates/modify-test-subject.json.tmpl > temp-modify-test-subject-by-owner.json

MODIFY_TEST_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-test-subject-by-owner.json`

echo $MODIFY_TEST_SUBJECT_REQUEST | jq

#!/bin/bash

# En este caso el registrador solicita un cambio del sujeto al nodo adminisytrador
# La política indica que si el que invoca es el registrador, se debe aprobar el cambio
# La aprobación del cambio la hace el nodo del presidente. 

export TEST_SUBJECT_ID=`cat .test_subject_id`
export TEST_SUBJECT_LOCATION="China"

# Cargamos la descripcion de los nodos
source nodes_definition

export NODEREGIS_PRIVATE_KEY=`cat .credentials.${node_name[1]} | sed -n 's/^PRIVATE_KEY: \(.*\)$/\1/p'`

echo $NODEREGIS_PRIVATE_KEY

# El registrador firma la solicitud de modificacion del sujeto
REQUEST_TO_SIGN="{\"subject_id\":\"$TEST_SUBJECT_ID\",\"payload\":{\"Json\":{\"temperature\":100,\"location\":\"${TEST_SUBJECT_LOCATION}\"}}}"

echo $REQUEST_TO_SIGN
./taple-tools/scripts/taple-sign $NODEREGIS_PRIVATE_KEY "$REQUEST_TO_SIGN" > temp-modify-test-signed.json

echo "Enviando solicitud de cambio a nodo ${node_name[0]}"

MODIFY_TEST_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-test-signed.json`

echo $MODIFY_TEST_SUBJECT_REQUEST | jq

MODIFY_TEST_SUBJECT_REQUEST_ID=`jq -r .request_id <<< $MODIFY_TEST_SUBJECT_REQUEST`

echo "Aprobando la petición con request_id $MODIFY_TEST_SUBJECT_REQUEST_ID"

APPROVAL=`curl --silent --location --request PUT "http://localhost:3002/api/approvals/$MODIFY_TEST_SUBJECT_REQUEST_ID" \
--header 'Content-Type: application/json' \
--data-raw '{
    "approvalType": "Accept"
}'`

echo "Approve result: $APPROVAL"

[[ $APPROVAL == "null" ]] && echo "Peticion aprobada y subject modificado" || echo "Error al aprobar la solicitud de modificacion el sujeto"
#!/bin/bash

# En este caso el Administrador hace un cambio del sujeto
# La política indica que si el que el cambio lo realiza el propietario, se debe aprobar el cambio
# La aprobación del cambio la hace el nodo del presidente.

source ./modify-record-by-owner-request.sh

export MODIFY_RECORD_ERROR_REQUEST_ID=`cat .modify_record_request_id`

echo "El registrador intenta aprobar la petición con request_id $MODIFY_RECORD_ERROR_REQUEST_ID"

APPROVAL=`curl --silent --location --request PUT "http://localhost:3001/api/approvals/$MODIFY_RECORD_ERROR_REQUEST_ID" \
--header 'Content-Type: application/json' \
--data-raw '{
    "approvalType": "Accept"
}'`

echo "Approve result: $APPROVAL"

[[ $APPROVAL == "null" ]] && echo "Peticion aprobada y subject modificado" || echo "Error al aprobar la solicitud de modificacion el sujeto"



echo "El secretario intenta aprobar la petición con request_id $MODIFY_RECORD_ERROR_REQUEST_ID"

APPROVAL=`curl --silent --location --request PUT "http://localhost:3000/api/approvals/$MODIFY_RECORD_ERROR_REQUEST_ID" \
--header 'Content-Type: application/json' \
--data-raw '{
    "approvalType": "Accept"
}'`

echo "Approve result: $APPROVAL"

[[ $APPROVAL == "null" ]] && echo "Peticion aprobada y subject modificado" || echo "Error al aprobar la solicitud de modificacion el sujeto"

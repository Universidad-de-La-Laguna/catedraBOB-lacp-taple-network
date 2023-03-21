#!/bin/bash

# En este caso el Administrador hace un cambio del sujeto
# La política indica que si el que el cambio lo realiza el propietario, se debe aprobar el cambio
# La aprobación del cambio la hace el nodo del presidente. 
export MODIFY_RECORD_REQUEST_ID=`cat .modify_record_request_id`

echo "Aprobando la petición con request_id $MODIFY_RECORD_REQUEST_ID"

APPROVAL=`curl --silent --location --request PUT "http://localhost:3002/api/approvals/$MODIFY_RECORD_REQUEST_ID" \
--header 'Content-Type: application/json' \
--data-raw '{
    "approvalType": "Accept"
}'`

echo "Approve result: $APPROVAL"

[[ $APPROVAL == "null" ]] && echo "Peticion aprobada y subject modificado" || echo "Error al aprobar la solicitud de modificacion el sujeto"
#!/bin/bash
set -e

# E registrador solicita un cambio del sujeto "LACP" al nodo administrador
# La política indica que si el que invoca es el registrador, el cambio no necesita aprobación

export LACP_SUBJECT_ID=`cat .lacp_id`
export DILIGENCE_SUBJECT_ID=`cat .diligence_id`

# Cargamos la descripcion de los nodos
source nodes_definition

export NODEREGIS_PRIVATE_KEY=`cat .credentials.${node_name[1]} | sed -n 's/^PRIVATE_KEY: \(.*\)$/\1/p'`

echo $NODEREGIS_PRIVATE_KEY

# El registrador firma la solicitud de modificacion del sujeto
REQUEST_TO_SIGN="{\"subject_id\":\"$LACP_SUBJECT_ID\",\"payload\":{\"Json\":{\"community_name\":\"Edif. Atlántico\",\"community_address\":\"Avenida Atlántico\",\"president_name\":\"NombrePresi\",\"president_contact\":\"ContactoPresiaaaa@gmail.com\",\"secretary_name\":\"NombreAdmin\",\"secretary_contact\":\"ContactoAdmin@gmail.com\",\"diligence_subject_id\":\"$DILIGENCE_SUBJECT_ID\"}}}"

./bin/taple-sign $NODEREGIS_PRIVATE_KEY "$REQUEST_TO_SIGN" > temp-modify-lacp-signed.json

echo "Enviando solicitud de cambio a nodo ${node_name[0]}"

MODIFY_LACP_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-lacp-signed.json`

echo $MODIFY_LACP_SUBJECT_REQUEST | jq

MODIFY_LACP_SUBJECT_REQUEST_ID=`jq -r .request_id <<< $MODIFY_LACP_SUBJECT_REQUEST`

# ---------------------------------------------------------

#echo "Aprobando la petición con request_id $MODIFY_LACP_SUBJECT_REQUEST_ID"

#APPROVAL=`curl --silent --location --request PUT "http://localhost:3002/api/approvals/$MODIFY_LACP_SUBJECT_REQUEST_ID" \
#--header 'Content-Type: application/json' \
#--data-raw '{
#    "approvalType": "Accept"
#}'`

#echo "Approve result: $APPROVAL"

#[[ $APPROVAL == "null" ]] && echo "Peticion aprobada y subject modificado" || echo "Error al aprobar la solicitud de modificacion el sujeto"
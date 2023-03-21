#!/bin/bash
set -e

# Script de seguridad: El presidente y el secretario solicitan un cambio del sujeto "LACP".
# La política indica que si el que invoca no es el registrador, no se puede cambiar.

export LACP_SUBJECT_ID=`cat .lacp_id`
export DILIGENCE_SUBJECT_ID=`cat .diligence_id`

# Cargamos la descripcion de los nodos
source nodes_definition

export PRESIDENT_NODE_PRIVATE_KEY=`cat .credentials.${node_name[0]} | sed -n 's/^PRIVATE_KEY: \(.*\)$/\1/p'`
export SECRETARY_NODE_PRIVATE_KEY=`cat .credentials.${node_name[2]} | sed -n 's/^PRIVATE_KEY: \(.*\)$/\1/p'`
export REGISTRAR_NODE_PRIVATE_KEY=`cat .credentials.${node_name[1]} | sed -n 's/^PRIVATE_KEY: \(.*\)$/\1/p'`

REQUEST_TO_SIGN="{\"subject_id\":\"$LACP_SUBJECT_ID\",\"payload\":{\"Json\":{\"community_name\":\"Edif. Atlántico\",\"community_address\":\"Avenida Atlántico\",\"president_name\":\"NombrePresi\",\"president_contact\":\"ContactoPresiaaaa@gmail.com\",\"secretary_name\":\"NombreAdmin\",\"secretary_contact\":\"ContactoAdmin@gmail.com\",\"diligence_subject_id\":\"$DILIGENCE_SUBJECT_ID\"}}}"

# El presidente firma la solicitud de modificacion del sujeto
./bin/taple-sign $PRESIDENT_NODE_PRIVATE_KEY "$REQUEST_TO_SIGN" > temp-modify-lacp-signed.json

echo "Enviando solicitud de cambio con firma del presidente a nodo ${node_name[0]}"

MODIFY_LACP_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-lacp-signed.json`

echo $MODIFY_LACP_SUBJECT_REQUEST

# El secretario firma la solicitud de modificacion del sujeto
./bin/taple-sign $SECRETARY_NODE_PRIVATE_KEY "$REQUEST_TO_SIGN" > temp-modify-lacp-signed.json

echo "Enviando solicitud de cambio con firma del secretario a nodo ${node_name[0]}"

MODIFY_LACP_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-lacp-signed.json`

echo $MODIFY_LACP_SUBJECT_REQUEST

# El registrador firma la solicitud de modificacion del sujeto
./bin/taple-sign $REGISTRAR_NODE_PRIVATE_KEY "$REQUEST_TO_SIGN" > temp-modify-lacp-signed.json

echo "Enviando solicitud de cambio con firma del registrador a nodo ${node_name[0]}"

MODIFY_LACP_SUBJECT_REQUEST=`curl --silent --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY: 1234' \
--header 'Content-Type: application/json' \
--data @temp-modify-lacp-signed.json`

echo $MODIFY_LACP_SUBJECT_REQUEST | jq


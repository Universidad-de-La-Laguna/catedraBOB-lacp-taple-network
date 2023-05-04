#!/bin/bash

# Comprobar prerequisitos
if ! command -v jq &> /dev/null
then
    echo "jq could not be found"
    exit
fi

# Cargamos la descripcion de los nodos
source nodes_definition

# Sustitucion de variables
export SECRETARY_NODE_CONTROLLER_ID=`cat .credentials.${node_name[0]} | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`
export REGISTRAR_NODE_CONTROLLER_ID=`cat .credentials.${node_name[1]} | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`
export PRESIDENT_NODE_CONTROLLER_ID=`cat .credentials.${node_name[2]} | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`
export COMMONER_NODE_CONTROLLER_ID=`cat .credentials.${node_name[3]} | sed -n 's/^CONTROLLER_ID: \(.*\)$/\1/p'`

envsubst < templates/lacp-governance.json.tmpl > temp-lacp-governance.json

# Creacion de la gobernanza
CREATE_GOVERNANCE_RESULT=`curl -s --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY;' \
--header 'Content-Type: application/json' \
--data @temp-lacp-governance.json`

GOVERNANCE_SUBJECT_ID=`jq -r .subject_id <<< $CREATE_GOVERNANCE_RESULT`

echo "Gobernanza creada correctamente con subject_id: $GOVERNANCE_SUBJECT_ID"

echo -n $GOVERNANCE_SUBJECT_ID > .governance_subject_id
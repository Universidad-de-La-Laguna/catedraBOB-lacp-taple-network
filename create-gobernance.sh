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
envsubst < templates/lacp-gobernance.json.tmpl > temp-lacp-gobernance.json

# Creacion de la gobernanza
CREATE_GOBERNANCE_RESULT=`curl -s --location --request POST 'http://localhost:3000/api/requests' \
--header 'X-API-KEY;' \
--header 'Content-Type: application/json' \
--data @temp-lacp-gobernance.json`

GOBERNANCE_SUBJECT_ID=`jq -r .subject_id <<< $CREATE_GOBERNANCE_RESULT`

echo "Gobernanza creada correctamente con subject_id: $GOBERNANCE_SUBJECT_ID"

echo -n $GOBERNANCE_SUBJECT_ID > .gobernance_subject_id
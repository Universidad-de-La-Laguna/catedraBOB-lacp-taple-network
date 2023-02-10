#!/bin/bash

: ${TOOLS_IMAGE:=opencanarias/taple-tools:0.1}

# Cargamos la descripcion de los nodos
source nodes_definition

function download_tools() {
    echo "Downloading taple tools..."
    git clone https://github.com/opencanarias/taple-tools.git
    chmod +x ./taple-tools/scripts/taple-keygen
    chmod +x ./taple-tools/scripts/taple-sign
}

function initialize_firstnode_env_variables(){
    echo "Initializing ${node_name[0]} environment variables..."
    ./taple-tools/scripts/taple-keygen ed25519 > temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1s/.*:/PRIVATE_KEY:/' temp_variables.txt
    sed -i '2s/.*:/CONTROLLER_ID:/' temp_variables.txt
    sed -i '3s/.*:/PEER_ID:/' temp_variables.txt
    #copy content of temp_variables.txt to .env file
    cat temp_variables.txt >> .credentials.${node_name[0]}
    rm temp_variables.txt
    echo "TAPLE_HTTPPORT=3000" >> ${node_name[0]}.env
    echo "TAPLE_NETWORK_P2PPORT=40000" >> ${node_name[0]}.env
    echo "TAPLE_NETWORK_ADDR=/ip4/0.0.0.0/tcp" >> ${node_name[0]}.env
    echo "TAPLE_NODE_SECRETKEY="$(cat .credentials.${node_name[0]} | grep "PRIVATE_KEY:" | echo $(cut -d ":" -f 2)) >> ${node_name[0]}.env
}

function add_firstnode_to_docker_compose(){
    echo "Adding ${node_name[0]} node to docker-compose.yml..."
    export SERVICENAME=${node_name[0]}
    export PORT=3000
    export P2PPORT=40000
    export ENVFILE=${node_name[0]}.env
    cp -f templates/docker-compose.yml.tmpl docker-compose.yml
    cp templates/body.docker-compose.yml.tmpl temp.body.docker-compose.yml
    envsubst < temp.body.docker-compose.yml >> temp.docker-compose.yml
    #copy content of temp.docker-compose.yml to docker-compose.yml
    cat temp.docker-compose.yml >> docker-compose.yml
    rm temp.body.docker-compose.yml
    rm temp.docker-compose.yml
}

function initialize_node_env_variables(){
    echo "initializing ${node_name[$1]} environment variables..."
    ./taple-tools/scripts/taple-keygen ed25519 > temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1s/.*:/PRIVATE_KEY:/' temp_variables.txt
    sed -i '2s/.*:/CONTROLLER_ID:/' temp_variables.txt
    sed -i '3s/.*:/PEER_ID:/' temp_variables.txt
    #copy content of temp_variables.txt to .env file
    cat temp_variables.txt >> .credentials.${node_name[$1]}
    rm temp_variables.txt
    echo "TAPLE_HTTPPORT=300$1" >> ${node_name[$1]}.env
    echo "TAPLE_NETWORK_P2PPORT=4000$1" >> ${node_name[$1]}.env
    echo TAPLE_NETWORK_ADDR=/ip4/0.0.0.0/tcp >> ${node_name[$1]}.env
    echo "TAPLE_NODE_SECRETKEY="$(cat .credentials.${node_name[$1]} | grep "PRIVATE_KEY:" | echo $(cut -d ":" -f 2)) >> ${node_name[$1]}.env
    # La ip 172.27.0.2 siempre es la del nodo firstnode porque
    # la dirección de red se fija en el docker-compose y el 
    # nodo firstnode es el primero en arrancar
    echo "TAPLE_NETWORK_KNOWNNODES=/ip4/172.27.0.2/tcp/40000/p2p/"$(cat .credentials."${node_name[0]}" | grep "PEER_ID:" | echo $(cut -d ":" -f 2)) >> ${node_name[$1]}.env
}

function add_node_to_docker_compose(){
    echo "Adding ${node_name[$1]} to docker-compose.yml..."
    export SERVICENAME=${node_name[$1]}
    export PORT=300$1
    export P2PPORT=4000$1
    export ENVFILE=${node_name[$1]}.env
    cp templates/body.docker-compose.yml.tmpl temp.body.docker-compose.yml
    envsubst < temp.body.docker-compose.yml >> temp.docker-compose.yml
    #copy content of temp.docker-compose.yml to docker-compose.yml
    cat temp.docker-compose.yml >> docker-compose.yml

    # Incluir dependencia de nodo firstnode
    echo "    depends_on:" >> docker-compose.yml
    echo "      - ${node_name[0]}" >> docker-compose.yml

    rm temp.body.docker-compose.yml
    rm temp.docker-compose.yml
}

function add_footer_to_docker_compose(){
    echo "Adding footer to docker-compose.yml..."
    cat templates/footer.docker-compose.yml.tmpl >> docker-compose.yml
}

echo "Removing old configuration..."
rm -rf *.env
rm -rf .credentials*
rm -rf docker-compose.yml
rm temp-*.json
rm .*_id

echo "Starting configuration..."

download_tools
initialize_firstnode_env_variables
add_firstnode_to_docker_compose

for ((i=1; i<$num_nodes; i++)); do
    initialize_node_env_variables $i 
    add_node_to_docker_compose $i
done

add_footer_to_docker_compose

echo "Removing taple-tools images..."
docker rm -f $(docker ps -aq --filter ancestor=${TOOLS_IMAGE})

echo "Node configuration finished. Please check docker-compose.yml file and .credentials.* files for your credentials."

# Start nodes
echo "Starting nodes..."
docker-compose up -d
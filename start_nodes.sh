#!/bin/bash

: ${TOOLS_IMAGE:=opencanarias/taple-tools:0.1}

function download_tools() {
    echo "Downloading taple tools..."
    git clone https://github.com/opencanarias/taple-tools.git
    chmod +x ./taple-tools/scripts/taple-keygen
    chmod +x ./taple-tools/scripts/taple-sign
}

function initialize_master_env_variables(){
    echo "Initializing master environment variables..."
    ./taple-tools/scripts/taple-keygen ed25519 > temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1s/.*:/MASTER_PRIVATE_KEY:/' temp_variables.txt
    sed -i '2s/.*:/MASTER_ID:/' temp_variables.txt
    sed -i '3s/.*:/MASTER_PEER_ID:/' temp_variables.txt
    #copy content of temp_variables.txt to .env file
    cat temp_variables.txt >> .credentials.master
    rm temp_variables.txt
    echo "TAPLE_HTTPPORT=3000" >> master.env
    echo "TAPLE_NETWORK_P2PPORT=40000" >> master.env
    echo "TAPLE_NETWORK_ADDR=/ip4/0.0.0.0/tcp" >> master.env
    echo "TAPLE_NODE_SECRETKEY="$(cat .credentials.master | grep "MASTER_PRIVATE_KEY:" | echo $(cut -d ":" -f 2)) >> master.env
}

function add_master_to_docker_compose(){
    echo "Adding master node to docker-compose.yml..."
    export SERVICENAME=master
    export PORT=3000
    export P2PPORT=40000
    export ENVFILE=master.env
    cp -f templates/docker-compose.yml.tmpl docker-compose.yml
    cp templates/body.docker-compose.yml.tmpl temp.body.docker-compose.yml
    envsubst < temp.body.docker-compose.yml >> temp.docker-compose.yml
    #copy content of temp.docker-compose.yml to docker-compose.yml
    cat temp.docker-compose.yml >> docker-compose.yml
    rm temp.body.docker-compose.yml
    rm temp.docker-compose.yml
}

function initialize_slave_env_variables(){
    echo "initializing slave $1 environment variables..."
    ./taple-tools/scripts/taple-keygen ed25519 > temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1d' temp_variables.txt
    sed -i '1s/.*:/SLAVE_PRIVATE_KEY:/' temp_variables.txt
    sed -i '2s/.*:/SLAVE_ID:/' temp_variables.txt
    sed -i '3s/.*:/SLAVE_PEER_ID:/' temp_variables.txt
    #copy content of temp_variables.txt to .env file
    cat temp_variables.txt >> .credentials.slave$1
    rm temp_variables.txt
    echo "TAPLE_HTTPPORT=300$1" >> slave$1.env
    echo "TAPLE_NETWORK_P2PPORT=4000$1" >> slave$1.env
    echo TAPLE_NETWORK_ADDR=/ip4/0.0.0.0/tcp >> slave$1.env
    echo "TAPLE_NODE_SECRETKEY="$(cat .credentials.slave$1 | grep "SLAVE_PRIVATE_KEY:" | echo $(cut -d ":" -f 2)) >> slave$1.env
    # La ip 172.27.0.2 siempre es la del nodo master porque
    # la dirección de red se fija en el docker-compose y el 
    # nodo master es el primero en arrancar
    echo "TAPLE_NETWORK_KNOWNNODES=/ip4/172.27.0.2/tcp/40000/p2p/"$(cat .credentials.master | grep "MASTER_PEER_ID:" | echo $(cut -d ":" -f 2)) >> slave$1.env
}

function add_slave_to_docker_compose(){
    echo "Adding slave node $1 to docker-compose.yml..."
    export SERVICENAME=slave$1
    export PORT=300$1
    export P2PPORT=4000$1
    export ENVFILE=slave$1.env
    cp templates/body.docker-compose.yml.tmpl temp.body.docker-compose.yml
    envsubst < temp.body.docker-compose.yml >> temp.docker-compose.yml
    #copy content of temp.docker-compose.yml to docker-compose.yml
    cat temp.docker-compose.yml >> docker-compose.yml

    # Incluir dependencia de nodo master
    echo "    depends_on:" >> docker-compose.yml
    echo "      - master" >> docker-compose.yml

    rm temp.body.docker-compose.yml
    rm temp.docker-compose.yml
}

function add_footer_to_docker_compose(){
    echo "Adding footer to docker-compose.yml..."
    cat templates/footer.docker-compose.yml.tmpl >> docker-compose.yml
}

   
# echo "How many nodes do you want to initialize? Must be more than 1. First #node is always the master."
# read num_nodes

# Fijamos el arranqe de una red de 3 nodos (administrador, registrador y presidente)
num_nodes=3

#validate input is a number and is more than 1
while ! [[ $num_nodes =~ ^[0-9]+$ ]] || [ $num_nodes -lt 2 ]; do
    echo "Invalid input. Please enter a number greater than 1."
    read num_nodes
done

echo "Removing old configuration..."
rm -rf *.env
rm -rf .credentials*
rm -rf docker-compose.yml
rm temp-*.json
rm .*_id

echo "Starting configuration..."

download_tools
initialize_master_env_variables
add_master_to_docker_compose

for ((i=1; i<$num_nodes; i++)); do
    initialize_slave_env_variables $i
    add_slave_to_docker_compose $i
done

add_footer_to_docker_compose

echo "Removing taple-tools images..."
docker rm -f $(docker ps -aq --filter ancestor=${TOOLS_IMAGE})

echo "Node configuration finished. Please check docker-compose.yml file and .credentials.* files for your credentials."

# Start nodes
echo "Starting nodes..."
docker-compose up -d
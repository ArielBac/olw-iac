#!/usr/bin/env bash

if [ $# -gt 0 ]; then

    if [ "$1" == "provision" ]; then
        COMMAND="apply --auto-approve"

    elif [ "$1" == "config" ]; then
        docker run -it --rm \
            -v $PWD:/opt \
            -w /opt \
            tombenevides/ansible:latest \
            ansible-playbook \
            -u ubuntu -i ansible/hosts \
            --private-key ./.pk/olw_pk.pem \
            ansible/playbook.yml

        exit 0

    elif [ "$1" == "build" ]; then
        ./sail provision && ./sail config

        exit 0
        
    else
        COMMAND="$@"
    fi
else
    COMMAND=""
fi

docker run -it --rm \ #Executa um container docker, --rm para apagar após a execução, -it diz que quero interagir com o container
    -u $(id -u):$(id -g) \
    --env-file ./.env \
    -v $PWD:/workspace \ #Mapeia a pasta atual para dentro da pasta workspace dentro do container
    -w /workspace \ #Diz que o diretório de trabalho do container é o workspace
    hashicorp/terraform:light $COMMAND #Imagem
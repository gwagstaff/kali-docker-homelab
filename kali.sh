#!/bin/sh

help="help     Show this help message
shell    Open shell in kali container
up:      Start kali container
build:   Build kali image and start container
stop:    Stop kali container
clean:   Stop and remove kali containers"

start_docker_service() {
    systemctl is-active --quiet docker || sudo systemctl start docker
}

start_docker_container() {
    sudo docker-compose -f "$(dirname "$0")/docker-compose.yml" up -d
}

open_shell() {
    docker-compose -f "$(dirname "$0")/docker-compose.yml" exec kali bash
}

case "$1" in
    "-h"|""|"--help"|"help") echo "$help";;
    "shell") start_docker_service &&
        start_docker_container &&
        xhost + &&
        open_shell;;
    "up") start_docker_service &&
        start_docker_container;;
    "build") start_docker_service &&
        sudo docker-compose -f "$(dirname "$0")/docker-compose.yml" build ;;
    "stop") echo "Stopping instance." &&
        start_docker_service &&
        docker-compose -f "$(dirname "$0")/docker-compose.yml" stop &&
        xhost - &&
        echo "Done stopping.";;
    "clean") echo "Cleaning instance." &&
        start_docker_service &&
        docker-compose -f "$(dirname "$0")/docker-compose.yml" down &&
        xhost - &&
        echo "Done cleaning.";;
esac


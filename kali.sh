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
    docker container inspect kali_docker > /dev/null 2>&1 || sudo docker-compose up -d
}

case "$1" in
    "-h"|""|"--help"|"help") echo "$help";;
    "shell") start_docker_service && start_docker_container && xhost + && docker-compose exec kali bash;;
    "up") start_docker_service && start_docker_container;;
    "build") start_docker_service && sudo docker-compose up --build -d;;
    "stop") echo "Stopping instance." && start_docker_service && docker-compose stop && xhost - && echo "Done.";;
    "clean") echo "Cleaning instance." && start_docker_service && docker-compose down && xhost - && echo "Done.";;
esac


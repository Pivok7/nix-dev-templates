#!/bin/sh
# Don't use "set -e"
# We want to shutdown when user presses ctrl-c

build() {
    sudo docker build -t pytorch-rocm .
}

run() {
    sudo docker compose up
    sudo docker compose down
}

clean() {
    sudo docker image prune
}

purge_images() {
    sudo docker compose down --rmi all
}

purge_volumes() {
    sudo docker compose down --volumes
}

help() {
    echo "Possible arguments:"
    echo "-> build          - build the project"
    echo "-> run            - run the project"
    echo "-> clean          - clean dangling images"
    echo "-> purge_images   - remove all images from this project"
    echo "-> purge_volumes  - remove all volumes from this project"
}

if [ $# -eq 0 ]; then
    help
    exit
else
    if ! docker info > /dev/null 2>&1; then
	sudo systemctl start docker
    fi
fi

while [ $# -gt 0 ]; do
    case $1 in
	build)
	    build
	    echo "-=- Build finished -=-"
	    echo ""
	;;
	run) run ;;
	clean) clean ;;
	purge_images) purge_images ;;
	purge_volumes) purge_volumes ;;
	*)
	    echo "Invalid argument: $1"
	    help
	    exit
	;;
    esac

    shift
done

#!/bin/sh
# Don't use "set -e"
# We want to shutdown when user presses ctrl-c

IMAGE_ROCM=pytorch-rocm
IMAGE_CUDA=pytorch-cuda

build_rocm() {
    sudo docker build -f Dockerfile-rocm -t ${IMAGE_ROCM} .
}

build_cuda() {
    sudo docker build -f Dockerfile-cuda -t ${IMAGE_CUDA} .
}

run_rocm() {
    docker run --rm \
	--device=/dev/kfd \
	--device=/dev/dri \
	--group-add video \
	${IMAGE_ROCM} rocm
}

run_cuda() {
    sudo docker run --rm \
	--device=nvidia.com/gpu=all \
	${IMAGE_CUDA}
}

clean() {
    sudo docker image prune
}

help() {
    echo "Possible arguments:"
    echo "-> build_rocm     - build the project (rocm version)"
    echo "-> build_cuda     - build the project (cuda version)"
    echo "-> run_rocm       - run the project (rocm version)"
    echo "-> run_cuda       - run the project (cuda version)"
    echo "-> clean          - clean dangling images"
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
	build_rocm) build_rocm ;;
	build_cuda) build_cuda ;;
	run_rocm) run_rocm ;;
	run_cuda) run_cuda ;;
	clean) clean ;;
	*)
	    echo "Invalid argument: $1"
	    help
	    exit
	;;
    esac

    shift
done

#!/bin/bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BEAMLINE_PODS_DIR="$(dirname "$SCRIPT_DIR")"
export NBS_PODS_DIR="$(dirname "$BEAMLINE_PODS_DIR")/nbs-pods"
export BEAMLINE_NAME="$(basename "$BEAMLINE_PODS_DIR" | sed 's/-pods$//')"

if [ ! -d "$NBS_PODS_DIR" ]; then
    echo "Error: nbs-pods directory not found at $NBS_PODS_DIR"
    echo "Please ensure nbs-pods is cloned in the same parent directory as this repository"
    exit 1
fi

# Source the library functions
source "$NBS_PODS_DIR/scripts/nbs-pods-lib.sh"

# Load beamline-specific services
if [ -f "$BEAMLINE_PODS_DIR/scripts/services.sh" ]; then
    source "$BEAMLINE_PODS_DIR/scripts/services.sh"
else
    BEAMLINE_SERVICES=()
fi

# Combine all services
ALL_SERVICES=(
    "${BASE_SERVICES[@]}"
    "${BEAMLINE_SERVICES[@]}"
)

usage() {
    echo "Usage: $0 [start [--dev]|stop|build] [service1 service2 ... | image1 image2 ...]"
    echo "If no services or images are specified, all will be managed."
    echo ""
    print_usage
    exit 1
}

# Main execution
if [ $# -eq 0 ]; then
    usage
elif [ "$1" = "start" ]; then
    shift
    dev_mode=false
    if [ "$1" = "--dev" ]; then
        dev_mode=true
        shift
    fi
    if [ $# -eq 0 ]; then
        start_all_services "$dev_mode"
    else
        for service in "$@"; do
            start_service "$service" "$dev_mode"
        done
    fi
elif [ "$1" = "stop" ]; then
    shift
    if [ $# -eq 0 ]; then
        stop_all_services
    else
        for service in "$@"; do
            stop_service "$service"
        done
    fi
elif [ "$1" = "build" ]; then
    shift
    if [ $# -eq 0 ]; then
        build_all_images
    else
        for image in "$@"; do
            build_image "$image"
        done
    fi
else
    usage
fi

echo "$BEAMLINE_NAME-pods operation completed successfully."

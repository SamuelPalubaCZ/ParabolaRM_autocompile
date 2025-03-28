#!/bin/bash

# Get script directory
script_dir=$(dirname "$(readlink -f "$0")")
project_root=$(dirname "$script_dir")

# Extract function
extract() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: extract <archive> <destination>"
        return 1
    fi

    if [ "$unzip_manager" = "7z" ]; then
        echo "Extracting $1 to $2"
        mkdir -p "$2"
        7z x "$1" "-o$2"
    else
        echo "Extract manager not found"
        return 1
    fi
}
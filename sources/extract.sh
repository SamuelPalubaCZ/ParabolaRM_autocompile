#!/bin/sh

# Extract Linux Kernel for Remarkable kernel compile script

# Extract function
extract() {
    if [ "$unzip_manager" = "7z" ]; then
        7z x "$1" "-o$2"
    else
        echo "Extract manager not found"
        return 1
    fi
}
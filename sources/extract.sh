#!/bin/sh

# Extract Linux Kernel for Remarkable kernel compile script

# Extract function
extract() {
    if [ "$unzip_manager" = "7z" ]; then
        7z x "$1" "-o$2"
    elif [ "$unzip_manager" = "unzip" ]; then
        unzip "$1" -d "$2"
    elif [ "$unzip_manager" = "pigz" ]; then
        pigz -d -c "$1" | tar xf - -C "$2"
    else
        echo "Extract manager not found"
        return 1
    fi
}
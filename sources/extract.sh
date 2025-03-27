#!/bin/sh

# Extract Linux Kernel for Remarkable kernel compile script

# Extract function
extract() {
    if [ "$unzip_manager" = "7z" ]; then
        7z x "$1" -o"$2"
    elif [ "$unzip_manager" = "unzip" ]; then
        unzip "$1" -d "$2" -v
    elif [ "$unzip_manager" = "tar" ]; then
        tar -xvf "$1" -C "$2"
    elif [ "$unzip_manager" = "pigz" ]; then
        pigz -d "$1" -c "$2"
    elif [ "$unzip_manager" = "gunzip" ]; then
        gunzip "$1" -c "$2"
    elif [ "$unzip_manager" = "bzip2" ]; then
        bzip2 -d "$1" -c "$2"
    else
        echo "Unzip manager not found"
    fi
}
#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# List of dependencies
dependencies=${dependencies:="git wget aria2"}

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}

# Remarkable kernel source URL
kernel_url=${kernel_url:="https://codeload.github.com/reMarkable/linux/zip/refs/heads/lars/zero-gravitas_4.9"}

download () {
downloader=${downloader:="aria2"}
if [$downloader="aria2"]; then
aria2c -x16 $1 -d $2
fi
}

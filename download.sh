#!/bin/sh
# Download function for Remarkable kernel compile script

download () {
downloader=${downloader:="aria2"}
if [$downloader="aria2"]; then
aria2c -x16 $1 -d $2
fi
}

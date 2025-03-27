#!/bin/sh

dir_base="/workspaces/ParabolaRM_autocompile/sources/base.sh"
dir_download="/workspaces/ParabolaRM_autocompile/sources/download.sh"
dir_pkg_detection="/workspaces/ParabolaRM_autocompile/sources/pkg_detection.sh"
dir_download_everything="/workspaces/ParabolaRM_autocompile/sources/download_everything.sh"
dir_config="/workspaces/ParabolaRM_autocompile/config.sh"

# Source the base.sh script
source $dir_base

# Source pkg_detection.sh script
source $dir_pkg_detection

# Download function for Remarkable kernel compile script

download () {
rm -rf $2
mkdir -p $2
if [ "$download_manager" = "wget" ]; then
    wget -c $1 -P $2
elif [ "$download_manager" = "curl" ]; then
    curl -L $1 -o $2
elif [ "$download_manager" = "aria2c" ]; then
    if [ "$download_segmentation" = 1 ]; then
        aria2c $1 -d $2
    else
        xcmd="aria2c -x$download_segmentation $1 -d $2"
        bash -c "$xcmd"
    fi
elif [ "$download_manager" = "axel" ]; then
    if [ "$download_segmentation" = 1 ]; then
        axel -v -o $2 $1
    else
        axel -v -n $download_segmentation -o $2 $1
    fi
else
    echo "Download manager not found"
fi
}

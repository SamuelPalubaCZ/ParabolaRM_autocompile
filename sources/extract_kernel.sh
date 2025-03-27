#!/bin/sh

# Extract kernel for Remarkable kernel compile script


# Source extract.sh script via base.sh envs
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
source $dir_extract

# Extract kernel
extract_kernel() {
    # save default directory
    default_dir=$PWD
    
    extract "$kernel_download_dir/*.zip" "$extract_dir/kernel"
    
    # Change back to default directory  
    cd "$default_dir"
    echo "Kernel extracted"
}

if [ "$extract_kernel" = true ]; then
    extract_kernel
fi
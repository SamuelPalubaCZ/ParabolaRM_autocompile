#!/bin/sh

# Extract kernel for Remarkable kernel compile script


# Source extract.sh script via base.sh envs
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
source $dir_extract
# Extract kernel
extract_kernel() {
    extract "$zip_file" "$extract_dir/kernel"
    
    echo "Kernel extracted"
}

if [ "$extract_kernel" = true ]; then
    extract_kernel
fi
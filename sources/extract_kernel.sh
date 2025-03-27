#!/bin/sh

# Source extract.sh script via base.sh envs
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
source $dir_extract

# Extract kernel
extract_kernel() {
    # Find the kernel zip file
    zip_file=$(find "$kernel_download_dir" -name "*.zip" -type f)
    
    if [ -z "$zip_file" ]; then
        echo "No zip file found in $kernel_download_dir"
        return 1
    fi
    
    echo "Found kernel zip: $zip_file"
    extract "$zip_file" "$kernel_dir"
    
    # Remove zip file after successful extraction
    rm -f "$zip_file"
    
    echo "Kernel extracted"
}

# Remove the automatic execution - let install.sh control this
# if [ "$extract_kernel" = true ]; then
#     extract_kernel
# fi
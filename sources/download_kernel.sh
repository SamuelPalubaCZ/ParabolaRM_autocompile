#!/bin/bash
# Download kernel script for ParabolaRM autocompile

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"

# Source the base.sh script
. "${project_root}/sources/base.sh"

# Source logging.sh script
. "${project_root}/sources/logging.sh"
init_logger "download_kernel" "${BASH_SOURCE[1]:-main}"

# Source download.sh script
. "${project_root}/sources/download.sh"

# Download kernel function
# Add file verification before returning success

download_kernel() {
    log_info "Starting kernel download from: $kernel_url"
    download $kernel_url $kernel_download_dir
    download_status=$?
    
    if [ $download_status -eq 0 ]; then
        log_info "✓ Kernel download completed"
        
        # Verify files exist in the directory if verification is enabled
        if [ "$verify_downloads" = true ]; then
            file_count=$(find "$kernel_download_dir" -type f | wc -l)
            log_detail "Files found in kernel download directory: $file_count"
            
            if [ $file_count -eq 0 ]; then
                log_warning "No files found in kernel download directory"
                return 1
            fi
            log_info "✓ Verified kernel download files exist"
        fi
        
        return 0
    else
        log_error "Kernel download failed with status: $download_status"
        return 1
    fi
}

# Only run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    download_kernel
fi
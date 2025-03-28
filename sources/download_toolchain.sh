#!/bin/bash
# Download toolchain script for ParabolaRM autocompile

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"

# Source the base.sh script
. "${project_root}/sources/base.sh"

# Source logging.sh script
. "${project_root}/sources/logging.sh"
init_logger "download_toolchain" "${BASH_SOURCE[1]:-main}"

# Source download.sh script
. "${project_root}/sources/download.sh"

# Download toolchain function
# Add file verification before returning success

download_toolchain() {
    log_info "Starting toolchain download from: $toolchain_url"
    download $toolchain_url $toolchain_download_dir
    download_status=$?
    
    if [ $download_status -eq 0 ]; then
        log_info "✓ Toolchain download completed"
        
        # Verify files exist in the directory if verification is enabled
        if [ "$verify_downloads" = true ]; then
            file_count=$(find "$toolchain_download_dir" -type f | wc -l)
            log_detail "Files found in toolchain download directory: $file_count"
            
            if [ $file_count -eq 0 ]; then
                log_warning "No files found in toolchain download directory"
                return 1
            fi
            log_info "✓ Verified toolchain download files exist"
        fi
        
        return 0
    else
        log_error "Toolchain download failed with status: $download_status"
        return 1
    fi
}

# Only run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    download_toolchain
fi
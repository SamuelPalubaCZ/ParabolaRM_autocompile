#!/bin/bash
# Download function for Remarkable kernel compile script

# Source logging if not already sourced
if [ -z "$CURRENT_LOG_FILE" ]; then
    # Set project root directory
    project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"
    
    # Source the base.sh script
    . "${project_root}/sources/base.sh"
    
    # Source logging.sh script
    . "${project_root}/sources/logging.sh"
    init_logger "download" "${BASH_SOURCE[1]:-main}"
fi

download() {
    log_info "Starting download: URL=$1, Destination=$2"
    
    # Get filename from URL
    filename=$(basename "$1")
    log_detail "Target filename: $filename"
    
    # Check if file already exists and we should reuse it
    if [ "$reuse_existing_downloads" = true ] && [ -d "$2" ]; then
        existing_file=$(find "$2" -type f | head -1)
        if [ -n "$existing_file" ]; then
            log_info "Found existing download in $2"
            
            # If it's a zip file that should have .zip extension but doesn't, rename it
            if [[ "$1" == *".zip"* ]] && [[ "$existing_file" != *.zip ]] && [[ "$existing_file" != *.ZIP ]]; then
                log_info "File doesn't have .zip extension, renaming..."
                mv "$existing_file" "$2/${filename}.zip"
                log_info "✓ Renamed to: $2/${filename}.zip"
                return 0
            fi
            
            log_info "✓ Using existing download"
            return 0
        fi
    fi
    
    # Only delete if configured to do so
    if [ "$delete_existing_downloads" = true ]; then
        rm -rf "$2"
        log_detail "Removed old directory: $2"
    fi
    
    # Create directory if it doesn't exist
    mkdir -p "$2"
    log_detail "Created directory (if it didn't exist): $2"
    
    # Try the configured download manager first
    download_status=1
    
    if [ "$download_manager" = "aria2c" ] && command -v aria2c &> /dev/null; then
        log_info "Using aria2c to download"
        if [ "$download_segmentation" = 1 ]; then
            log_detail "Using single connection"
            aria2c "$1" -d "$2" -o "$filename"
            download_status=$?
        else
            log_detail "Using $download_segmentation connections"
            aria2c -x$download_segmentation "$1" -d "$2" -o "$filename"
            download_status=$?
        fi
    elif [ "$download_manager" = "wget" ] && command -v wget &> /dev/null; then
        log_info "Using wget to download"
        wget -c "$1" -O "$2/$filename"
        download_status=$?
    elif [ "$download_manager" = "curl" ] && command -v curl &> /dev/null; then
        log_info "Using curl to download"
        curl -L "$1" -o "$2/$filename"
        download_status=$?
    else
        log_warning "Configured download manager '$download_manager' not found or not specified"
        log_info "Trying fallback download methods..."
        
        # Try wget as fallback
        if command -v wget &> /dev/null; then
            log_info "Using wget as fallback"
            wget -c "$1" -O "$2/$filename"
            download_status=$?
        # Try curl as second fallback
        elif command -v curl &> /dev/null; then
            log_info "Using curl as fallback"
            curl -L "$1" -o "$2/$filename"
            download_status=$?
        # Try aria2c as third fallback
        elif command -v aria2c &> /dev/null; then
            log_info "Using aria2c as fallback"
            aria2c "$1" -d "$2" -o "$filename"
            download_status=$?
        else
            log_error "No download tools found. Please install wget, curl, or aria2c"
            return 1
        fi
    fi
    
    # Check if download was successful
    if [ $download_status -eq 0 ]; then
        log_info "✓ Download completed successfully"
        # Verify file exists
        if [ -f "$2/$filename" ]; then
            log_detail "File verified: $2/$filename"
            # If it's not a zip file but should be, rename it
            if [[ "$1" == *".zip"* ]] && [[ "$filename" != *.zip ]]; then
                log_info "File doesn't have .zip extension, renaming..."
                mv "$2/$filename" "$2/${filename}.zip"
                log_info "✓ Renamed to: $2/${filename}.zip"
            fi
        else
            log_error "File not found after download: $2/$filename"
            return 1
        fi
        return 0
    else
        log_error "Download failed with status: $download_status"
        return 1
    fi
}

# Only run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 2 ]; then
        log_error "Missing parameters"
        log_error "Usage: download.sh <url> <destination>"
        exit 1
    fi
    
    download "$1" "$2"
    exit $?
fi

#!/bin/bash
# Extract function for Remarkable kernel compile script

# Source logging if not already sourced
if [ -z "$CURRENT_LOG_FILE" ]; then
    # Set project root directory
    project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"
    
    # Source the base.sh script
    . "${project_root}/sources/base.sh"
    
    # Source logging.sh script
    . "${project_root}/sources/logging.sh"
    init_logger "extract" "${BASH_SOURCE[1]:-main}"
fi

# Extract function
extract() {
    log_info "Starting extraction process"
    if [ -z "$1" ] || [ -z "$2" ]; then
        log_error "Missing parameters"
        log_error "Usage: extract <archive> <destination>"
        return 1
    fi

    log_detail "Archive: $1"
    log_detail "Destination: $2"
    
    # Create destination directory
    mkdir -p "$2"
    log_detail "Created destination directory: $2"
    
    # Try the configured unzip manager first
    extract_status=1
    
    if [ "$unzip_manager" = "7z" ] && command -v 7z &> /dev/null; then
        log_info "Using 7z for extraction"
        7z x "$1" "-o$2"
        extract_status=$?
    elif [ "$unzip_manager" = "unzip" ] && command -v unzip &> /dev/null; then
        log_info "Using unzip for extraction"
        unzip -o "$1" -d "$2"
        extract_status=$?
    else
        log_warning "Configured unzip manager '$unzip_manager' not found or not specified"
        log_info "Trying fallback extraction methods..."
        
        # Try unzip as fallback
        if command -v unzip &> /dev/null; then
            log_info "Using unzip as fallback"
            unzip -o "$1" -d "$2"
            extract_status=$?
        # Try 7z as second fallback
        elif command -v 7z &> /dev/null; then
            log_info "Using 7z as fallback"
            7z x "$1" "-o$2"
            extract_status=$?
        # Try tar as third fallback (if it's a tar archive)
        elif command -v tar &> /dev/null && [[ "$1" == *".tar"* ]]; then
            log_info "Using tar as fallback"
            tar -xf "$1" -C "$2"
            extract_status=$?
        else
            log_error "No extraction tools found. Please install unzip, 7z, or tar"
            return 1
        fi
    fi
    
    if [ $extract_status -eq 0 ]; then
        log_info "✓ Extraction completed successfully"
    else
        log_error "Extraction failed with status: $extract_status"
    fi
    
    return $extract_status
}

# Only run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 2 ]; then
        log_error "Missing parameters"
        log_error "Usage: extract.sh <archive> <destination>"
        exit 1
    fi
    
    extract "$1" "$2"
    exit $?
fi
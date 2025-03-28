#!/bin/bash
# Extract kernel script for ParabolaRM autocompile

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"

# Source the base.sh script
. "${project_root}/sources/base.sh"

# Source logging.sh script
. "${project_root}/sources/logging.sh"
init_logger "extract_kernel" "${BASH_SOURCE[1]:-main}"

# Source extract.sh script
. "${project_root}/sources/extract.sh"

# Extract kernel
extract_kernel() {
    log_info "Starting kernel extraction process"
    # Find the kernel zip file
    log_detail "Searching for zip file in: $kernel_download_dir"
    
    # First try to find any zip files
    zip_file=$(find "$kernel_download_dir" -name "*.zip" -type f)
    
    # If no zip files found, try to find any files (might be missing extension)
    if [ -z "$zip_file" ]; then
        log_warning "No .zip files found, checking for any files..."
        any_file=$(find "$kernel_download_dir" -type f | head -1)
        
        if [ -n "$any_file" ]; then
            log_info "Found a file without .zip extension: $any_file"
            # Rename to add .zip extension
            new_zip_file="${any_file}.zip"
            log_info "Renaming to: $new_zip_file"
            mv "$any_file" "$new_zip_file"
            zip_file="$new_zip_file"
        else
            log_error "No files found in $kernel_download_dir"
            log_error "Download may have failed. Please check download logs."
            return 1
        fi
    fi
    
    log_info "Found kernel zip: $zip_file"
    log_info "Extracting to: $kernel_dir"
    
    # Test if the file is actually a zip file
    file_type=$(file -b "$zip_file")
    log_detail "File type: $file_type"
    
    if [[ "$file_type" == *"ZIP"* || "$file_type" == *"Zip"* ]]; then
        log_detail "Confirmed file is a ZIP archive"
    else
        log_warning "File doesn't appear to be a ZIP archive"
        log_warning "Will attempt extraction anyway..."
    fi
    
    # Attempt extraction
    extract "$zip_file" "$kernel_dir"
    extract_status=$?
    
    # In the extract_kernel function, modify the part that removes the zip file:
    
    # After successful extraction, only remove if configured to do so
    if [ $extract_status -eq 0 ]; then
        if [ "$delete_after_extraction" = true ]; then
            log_detail "Removing zip file after extraction"
            rm -f "$zip_file"
            log_info "✓ Removed zip file after extraction"
        else
            log_info "✓ Keeping zip file after extraction (delete_after_extraction=false)"
        fi
        log_info "✓ Kernel extraction completed successfully"
        return 0
    } else {
        log_error "Extraction failed with status: $extract_status"
        return 1
    fi
}

# Only run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    extract_kernel
fi
#!/bin/bash
# Remarkable kernel compile script for ParabolaRM distro (Parabola GNU/Linux-libre mod)

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"
echo "[INSTALL] Project root set to: $project_root"

# Source the base.sh script first to get sudo_password and logging settings
echo "[INSTALL] Sourcing base.sh script..."
. "${project_root}/sources/base.sh"

# Source the logging script
echo "[INSTALL] Sourcing logging.sh script..."
. "${project_root}/sources/logging.sh"

# Delete previous logs if configured to do so
delete_logs

# Initialize logger for install script
init_logger "install" "main"

# Enable passwordless sudo immediately (before any other operations)
log_info "Enabling passwordless sudo..."
. "${project_root}/sources/no_passwd_sudo.sh"
no_passwd_sudo enable "$sudo_password"
if [ $? -eq 0 ]; then
    log_info "✓ Passwordless sudo enabled successfully"
    # Verify sudo is working without password
    if sudo -n true 2>/dev/null; then
        log_info "✓ Verified passwordless sudo is working"
    else
        log_warning "Passwordless sudo not working correctly, installation may fail"
    fi
else
    log_warning "Failed to enable passwordless sudo, installation may fail"
fi

# Set download_everything to true to ensure downloads happen
download_everything=true
install_dependencies=true
log_debug "download_everything set to: $download_everything"
log_debug "install_dependencies set to: $install_dependencies"

# Source the remaining scripts
log_debug "Sourcing install_dependencies.sh script..."
. "${project_root}/sources/install_dependencies.sh"
log_debug "Sourcing download_kernel.sh script..."
. "${project_root}/sources/download_kernel.sh"
log_debug "Sourcing download_toolchain.sh script..."
. "${project_root}/sources/download_toolchain.sh"
log_debug "Sourcing extract_kernel.sh script..."
. "${project_root}/sources/extract_kernel.sh"

# Modify the cleanup section to respect the new settings

# Clean up directories if needed
log_info "Checking cleanup settings..."
if [ "$delete_existing_downloads" = true ]; then
    log_info "Cleaning up directories as delete_existing_downloads=true..."
    
    log_detail "Removing kernel directory..."
    remove_kernel
    log_detail "Removing toolchain directory..."
    remove_toolchain
    log_detail "Removing downloads directory..."
    remove_downlands
    log_detail "Removing extracted directory..."
    remove_extracted
else
    log_info "Skipping cleanup as delete_existing_downloads=false"
fi

# Create required directories (keep this part unchanged)
log_info "Creating required directories..."
log_detail "Creating kernel directory: $kernel_dir"
mkdir -p "$kernel_dir"
log_detail "Creating kernel download directory: $kernel_download_dir"
mkdir -p "$kernel_download_dir"
log_detail "Creating toolchain directory: $toolchain_dir"
mkdir -p "$toolchain_dir"
log_detail "Creating toolchain download directory: $toolchain_download_dir"
mkdir -p "$toolchain_download_dir"
log_detail "Creating extract directory for kernel: $extract_dir/kernel"
mkdir -p "$extract_dir/kernel"
log_detail "Creating extract directory for toolchain: $extract_dir/toolchain"
mkdir -p "$extract_dir/toolchain"
log_detail "Creating logs directory: $logs_dir"
mkdir -p "$logs_dir"

# Install dependencies
if [ "$install_dependencies" = true ]; then
    log_info "Installing dependencies..."
    # Call the modified install_dependencies function
    install_dependencies "$dependencies"
    install_status=$?
    
    if [ $install_status -eq 0 ]; then
        log_info "✓ Dependencies installation completed successfully"
        
        # Verify all dependencies are actually installed
        missing_deps=()
        for dep in $dependencies; do
            if ! command -v $dep &> /dev/null; then
                # Special case for p7zip-full
                if [ "$dep" = "p7zip-full" ] && command -v 7z &> /dev/null; then
                    log_info "✓ Found 7z command from p7zip-full package"
                    continue
                # Special case for pigz
                elif [ "$dep" = "pigz" ] && [ -f "/usr/bin/pigz" ]; then
                    log_info "✓ Found pigz at /usr/bin/pigz"
                    continue
                # Special case for aria2
                elif [ "$dep" = "aria2" ] && command -v aria2c &> /dev/null; then
                    log_info "✓ Found aria2c command from aria2 package"
                    continue
                fi
                missing_deps+=("$dep")
            fi
        done
        
        if [ ${#missing_deps[@]} -gt 0 ]; then
            log_warning "Some dependencies still appear to be missing:"
            for missing in "${missing_deps[@]}"; do
                log_warning "Missing: $missing"
            done
            log_warning "Continuing anyway, but installation may fail"
            
            # Adjust download manager if aria2c is missing
            if [[ " ${missing_deps[*]} " =~ " aria2 " ]] && [ "$download_manager" = "aria2c" ]; then
                if command -v wget &> /dev/null; then
                    log_warning "Switching download manager from aria2c to wget"
                    download_manager="wget"
                elif command -v curl &> /dev/null; then
                    log_warning "Switching download manager from aria2c to curl"
                    download_manager="curl"
                fi
            fi
            
            # Adjust unzip manager if 7z is missing
            if [[ " ${missing_deps[*]} " =~ " p7zip-full " ]] && [ "$unzip_manager" = "7z" ]; then
                if command -v unzip &> /dev/null; then
                    log_warning "Switching unzip manager from 7z to unzip"
                    unzip_manager="unzip"
                fi
            fi
        else
            log_info "✓ All dependencies verified as installed"
        fi
    else
        log_warning "Dependencies installation reported errors"
        log_warning "Continuing anyway, but installation may fail"
        
        # Check for critical tools and adjust if needed
        if ! command -v "$download_manager" &> /dev/null && [ "$download_manager" = "aria2c" ]; then
            if command -v wget &> /dev/null; then
                log_warning "Switching download manager from aria2c to wget"
                download_manager="wget"
            elif command -v curl &> /dev/null; then
                log_warning "Switching download manager from aria2c to curl"
                download_manager="curl"
            fi
        fi
        
        if ! command -v "$unzip_manager" &> /dev/null && [ "$unzip_manager" = "7z" ]; then
            if command -v unzip &> /dev/null; then
                log_warning "Switching unzip manager from 7z to unzip"
                unzip_manager="unzip"
            fi
        fi
    fi
fi

# In the download section of install.sh

# Download everything
if [ "$download_everything" = true ]; then
    log_info "Starting downloads..."
    
    # Check for existing kernel download
    kernel_download_exists=false
    if [ "$reuse_existing_downloads" = true ] && [ -d "$kernel_download_dir" ]; then
        kernel_file_count=$(find "$kernel_download_dir" -type f | wc -l)
        if [ $kernel_file_count -gt 0 ]; then
            log_info "Found existing kernel download files: $kernel_file_count"
            kernel_download_exists=true
            kernel_download_status=0
        fi
    fi
    
    # Only download kernel if no existing download or not reusing
    if [ "$kernel_download_exists" = false ]; then
        log_info "Downloading kernel..."
        download_kernel
        kernel_download_status=$?
    else
        log_info "Using existing kernel download"
    fi
    
    # Check for existing toolchain download
    toolchain_download_exists=false
    if [ "$reuse_existing_downloads" = true ] && [ -d "$toolchain_download_dir" ]; then
        toolchain_file_count=$(find "$toolchain_download_dir" -type f | wc -l)
        if [ $toolchain_file_count -gt 0 ]; then
            log_info "Found existing toolchain download files: $toolchain_file_count"
            toolchain_download_exists=true
            toolchain_download_status=0
        fi
    fi
    
    # Only download toolchain if no existing download or not reusing
    if [ "$toolchain_download_exists" = false ]; then
        log_info "Downloading toolchain..."
        download_toolchain
        toolchain_download_status=$?
    else
        log_info "Using existing toolchain download"
    fi
    
    # Rest of the download section remains the same
    
    # Check download results
    if [ $kernel_download_status -eq 0 ] && [ $toolchain_download_status -eq 0 ]; then
        log_info "✓ All downloads completed successfully"
    else
        log_warning "Some downloads failed:"
        [ $kernel_download_status -ne 0 ] && log_warning "Kernel download failed with status: $kernel_download_status"
        [ $toolchain_download_status -ne 0 ] && log_warning "Toolchain download failed with status: $toolchain_download_status"
        
        # Try alternative download methods if primary method failed
        if [ $kernel_download_status -ne 0 ]; then
            log_info "Trying alternative download method for kernel..."
            original_download_manager="$download_manager"
            
            if [ "$download_manager" = "aria2c" ]; then
                if command -v wget &> /dev/null; then
                    download_manager="wget"
                    log_info "Switching to wget for kernel download"
                    download_kernel
                    kernel_download_status=$?
                elif command -v curl &> /dev/null; then
                    download_manager="curl"
                    log_info "Switching to curl for kernel download"
                    download_kernel
                    kernel_download_status=$?
                fi
            elif [ "$download_manager" = "wget" ]; then
                if command -v curl &> /dev/null; then
                    download_manager="curl"
                    log_info "Switching to curl for kernel download"
                    download_kernel
                    kernel_download_status=$?
                elif command -v aria2c &> /dev/null; then
                    download_manager="aria2c"
                    log_info "Switching to aria2c for kernel download"
                    download_kernel
                    kernel_download_status=$?
                fi
            elif [ "$download_manager" = "curl" ]; then
                if command -v wget &> /dev/null; then
                    download_manager="wget"
                    log_info "Switching to wget for kernel download"
                    download_kernel
                    kernel_download_status=$?
                elif command -v aria2c &> /dev/null; then
                    download_manager="aria2c"
                    log_info "Switching to aria2c for kernel download"
                    download_kernel
                    kernel_download_status=$?
                fi
            fi
            
            # Restore original download manager
            download_manager="$original_download_manager"
        fi
        
        if [ $toolchain_download_status -ne 0 ]; then
            log_info "Trying alternative download method for toolchain..."
            original_download_manager="$download_manager"
            
            if [ "$download_manager" = "aria2c" ]; then
                if command -v wget &> /dev/null; then
                    download_manager="wget"
                    log_info "Switching to wget for toolchain download"
                    download_toolchain
                    toolchain_download_status=$?
                elif command -v curl &> /dev/null; then
                    download_manager="curl"
                    log_info "Switching to curl for toolchain download"
                    download_toolchain
                    toolchain_download_status=$?
                fi
            elif [ "$download_manager" = "wget" ]; then
                if command -v curl &> /dev/null; then
                    download_manager="curl"
                    log_info "Switching to curl for toolchain download"
                    download_toolchain
                    toolchain_download_status=$?
                elif command -v aria2c &> /dev/null; then
                    download_manager="aria2c"
                    log_info "Switching to aria2c for toolchain download"
                    download_toolchain
                    toolchain_download_status=$?
                fi
            fi
            
            # Restore original download manager
            download_manager="$original_download_manager"
        fi
        
        # Final check after retries
        if [ $kernel_download_status -ne 0 ] || [ $toolchain_download_status -ne 0 ]; then
            log_warning "Some downloads still failed after retries"
            log_warning "Continuing anyway, but extraction may fail"
        else
            log_info "✓ All downloads completed successfully after retries"
        fi
    fi
fi

# Extract kernel
if [ "$extract_kernel" = true ]; then
    log_info "Starting kernel extraction..."
    extract_kernel
    extract_status=$?
    
    if [ $extract_status -eq 0 ]; then
        log_info "✓ Kernel extraction completed successfully"
    else
        log_error "Kernel extraction failed with status: $extract_status"
        
        # Try alternative extraction method
        log_info "Trying alternative extraction method..."
        original_unzip_manager="$unzip_manager"
        
        if [ "$unzip_manager" = "7z" ]; then
            if command -v unzip &> /dev/null; then
                unzip_manager="unzip"
                log_info "Switching to unzip for extraction"
                extract_kernel
                extract_status=$?
            fi
        elif [ "$unzip_manager" = "unzip" ]; then
            if command -v 7z &> /dev/null; then
                unzip_manager="7z"
                log_info "Switching to 7z for extraction"
                extract_kernel
                extract_status=$?
            fi
        fi
        
        # Restore original unzip manager
        unzip_manager="$original_unzip_manager"
        
        if [ $extract_status -ne 0 ]; then
            log_error "Kernel extraction failed even with alternative method"
            log_error "Cannot continue without kernel extraction"
            # Don't exit immediately, try to clean up first
            extract_failed=true
        else
            log_info "✓ Kernel extraction completed successfully with alternative method"
        fi
    fi
fi

# Disable passwordless sudo at the end of the script
log_info "Disabling passwordless sudo..."
no_passwd_sudo disable "$sudo_password"
if [ $? -eq 0 ]; then
    log_info "✓ Passwordless sudo disabled successfully"
else
    log_warning "Failed to disable passwordless sudo"
    log_warning "IMPORTANT: You may want to manually remove the passwordless sudo configuration"
fi

# Final status check
if [ "${extract_failed:-false}" = true ]; then
    log_error "Installation process failed due to kernel extraction failure"
    exit 1
else
    log_info "✓ Installation process completed"
    exit 0
fi
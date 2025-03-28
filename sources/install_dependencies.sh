#!/bin/bash
# Install dependencies for Remarkable kernel compile script

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"

# Source the base.sh script
. "${project_root}/sources/base.sh"

# Source logging.sh script
. "${project_root}/sources/logging.sh"
init_logger "install_dependencies" "${BASH_SOURCE[1]:-main}"

# Source pkg_detection.sh script
. "${project_root}/sources/pkg_detection.sh"
package_manager=$pkg_manager
log_info "Using package manager: $package_manager"
log_info "Using sudo for installation: $use_sudo"

# Map package names to their actual package names in different distributions
map_package_name() {
    local pkg="$1"
    local pkg_manager="$2"
    
    case "$pkg_manager" in
        apt)
            case "$pkg" in
                aria2) echo "aria2" ;;
                p7zip-full) echo "p7zip-full" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        pacman)
            case "$pkg" in
                aria2) echo "aria2" ;;
                p7zip-full) echo "p7zip" ;;
                pigz) echo "pigz" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        yum|dnf)
            case "$pkg" in
                aria2) echo "aria2" ;;
                p7zip-full) echo "p7zip" ;;
                pigz) echo "pigz" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        *)
            echo "$pkg"
            ;;
    esac
}

install_dependencies() {
    log_info "Starting dependency installation process"
    dependencies="$*"
    log_info "Dependencies to install: $dependencies"
    
    # Define sudo command based on use_sudo setting
    sudo_cmd=""
    if [ "$use_sudo" = true ]; then
        sudo_cmd="sudo"
        log_info "Using sudo for installations"
    else
        log_info "Not using sudo for installations"
    fi
    
    # Track installation failures
    local install_failed=false
    local updated=false
    
    for dep in $dependencies; do
        log_info "Checking for dependency: $dep"
        
        # Special case for p7zip-full - check for 7z command
        if [ "$dep" = "p7zip-full" ] && command -v 7z &> /dev/null; then
            log_info "✓ Found 7z command from p7zip-full package"
            continue
        # Special case for pigz - check for pigz file
        elif [ "$dep" = "pigz" ] && (command -v pigz &> /dev/null || [ -f "/usr/bin/pigz" ]); then
            log_info "✓ Found pigz"
            continue
        # Special case for aria2 - check for aria2c command
        elif [ "$dep" = "aria2" ] && command -v aria2c &> /dev/null; then
            log_info "✓ Found aria2c command from aria2 package"
            continue
        # General case - check if command exists
        elif command -v $dep &> /dev/null; then
            log_info "✓ Dependency already installed: $dep"
            continue
        fi
        
        # If we get here, we need to install the dependency
        log_warning "Dependency not found: $dep - Installing..."
        install_status=1  # Default to error status
        
        # Map package name to distribution-specific name
        pkg_name=$(map_package_name "$dep" "$pkg_manager")
        log_detail "Package name for $dep in $pkg_manager: $pkg_name"
        
        case "$pkg_manager" in
            apt)
                log_detail "Using APT to install $pkg_name"
                if [ "$updated" != true ]; then
                    log_detail "Updating APT repositories..."
                    $sudo_cmd apt-get update
                    updated=true
                fi
                $sudo_cmd apt-get install -y $pkg_name
                install_status=$?
                ;;
            pacman)
                log_detail "Using Pacman to install $pkg_name"
                if [ "$updated" != true ]; then
                    log_detail "Updating Pacman repositories..."
                    $sudo_cmd pacman -Sy
                    updated=true
                fi
                $sudo_cmd pacman -S --noconfirm $pkg_name
                install_status=$?
                ;;
            yum)
                log_detail "Using yum to install $pkg_name"
                $sudo_cmd yum install -y $pkg_name
                install_status=$?
                ;;
            dnf)
                log_detail "Using dnf to install $pkg_name"
                $sudo_cmd dnf install -y $pkg_name
                install_status=$?
                ;;
            brew)
                log_detail "Using brew to install $pkg_name"
                brew install $pkg_name
                install_status=$?
                ;;
            apk)
                log_detail "Using apk to install $pkg_name"
                $sudo_cmd apk add $pkg_name
                install_status=$?
                ;;
            zypper)
                log_detail "Using zypper to install $pkg_name"
                $sudo_cmd zypper install -y $pkg_name
                install_status=$?
                ;;
            emerge)
                log_detail "Using emerge to install $pkg_name"
                $sudo_cmd emerge $pkg_name
                install_status=$?
                ;;
            unknown)
                log_warning "Unknown package manager, please install the following dependency manually:"
                log_warning "REQUIRED: $dep"
                manual_pkg_manager=true
                unknown_pkg_manager=true
                install_status=1
                ;;
        esac
        
        # Verify installation was successful - ensure install_status is not empty
        if [ -n "$install_status" ] && [ $install_status -eq 0 ]; then
            # Double-check the command is now available
            if [ "$dep" = "p7zip-full" ] && command -v 7z &> /dev/null; then
                log_info "✓ Found 7z command from p7zip-full package"
            # Special case for pigz which might not be in PATH
            elif [ "$dep" = "pigz" ] && (command -v pigz &> /dev/null || [ -f "/usr/bin/pigz" ]); then
                log_info "✓ Found pigz"
            # Special case for aria2 which provides aria2c command
            elif [ "$dep" = "aria2" ] && command -v aria2c &> /dev/null; then
                log_info "✓ Found aria2c command from aria2 package"
            elif command -v $dep &> /dev/null; then
                log_info "✓ Installation of $dep completed and verified"
            else
                log_warning "Installation of $dep reported success but command not found"
                install_failed=true
            fi
        else
            log_error "Installation of $dep failed with status: $install_status"
            install_failed=true
        fi
    done
    
    if [ "$install_failed" = true ]; then
        log_warning "Some dependencies failed to install"
        # Don't fail the entire script, just warn
        return 0
    else
        log_info "✓ All dependencies installation completed successfully"
        return 0
    fi
}

# Only run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    log_info "Calling install_dependencies with: $dependencies"
    install_dependencies $dependencies
fi
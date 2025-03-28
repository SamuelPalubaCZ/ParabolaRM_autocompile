#!/bin/bash
# Script to enable or disable passwordless sudo for the current user

echo "[NO_PASSWD_SUDO] Initializing no_passwd_sudo script"

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"
echo "[NO_PASSWD_SUDO] Project root set to: $project_root"

# Function to enable passwordless sudo
enable_no_passwd_sudo() {
    local password="$1"
    local username=$(whoami)
    
    echo "[NO_PASSWD_SUDO] Enabling passwordless sudo for user: $username"
    
    # Create a temporary sudoers file
    local temp_file=$(mktemp)
    echo "[NO_PASSWD_SUDO] Created temporary file: $temp_file"
    
    # Add the sudo rule to the temporary file
    echo "$username ALL=(ALL) NOPASSWD: ALL" > "$temp_file"
    echo "[NO_PASSWD_SUDO] Added sudo rule to temporary file"
    
    # Use sudo to append the rule to the sudoers.d directory
    echo "$password" | sudo -S cp "$temp_file" "/etc/sudoers.d/no_passwd_$username"
    local status=$?
    
    # Remove the temporary file
    rm -f "$temp_file"
    echo "[NO_PASSWD_SUDO] Removed temporary file"
    
    if [ $status -eq 0 ]; then
        echo "[NO_PASSWD_SUDO] ✓ Successfully enabled passwordless sudo for $username"
        # Set proper permissions
        echo "$password" | sudo -S chmod 0440 "/etc/sudoers.d/no_passwd_$username"
        return 0
    else
        echo "[NO_PASSWD_SUDO] ⚠️ Failed to enable passwordless sudo"
        return 1
    fi
}

# Function to disable passwordless sudo
disable_no_passwd_sudo() {
    local password="$1"
    local username=$(whoami)
    
    echo "[NO_PASSWD_SUDO] Disabling passwordless sudo for user: $username"
    
    # Check if the file exists
    if [ -f "/etc/sudoers.d/no_passwd_$username" ]; then
        echo "[NO_PASSWD_SUDO] Found sudoers file, removing..."
        echo "$password" | sudo -S rm -f "/etc/sudoers.d/no_passwd_$username"
        local status=$?
        
        if [ $status -eq 0 ]; then
            echo "[NO_PASSWD_SUDO] ✓ Successfully disabled passwordless sudo for $username"
            return 0
        else
            echo "[NO_PASSWD_SUDO] ⚠️ Failed to disable passwordless sudo"
            return 1
        fi
    else
        echo "[NO_PASSWD_SUDO] No passwordless sudo configuration found for $username"
        return 0
    fi
}

# Main function to handle command line arguments
no_passwd_sudo() {
    if [ $# -lt 2 ]; then
        echo "[NO_PASSWD_SUDO] ⚠️ Error: Insufficient arguments"
        echo "[NO_PASSWD_SUDO] Usage: no_passwd_sudo enable|disable password"
        return 1
    fi
    
    local action="$1"
    local password="$2"
    
    case "$action" in
        enable)
            enable_no_passwd_sudo "$password"
            return $?
            ;;
        disable)
            disable_no_passwd_sudo "$password"
            return $?
            ;;
        *)
            echo "[NO_PASSWD_SUDO] ⚠️ Error: Invalid action. Use 'enable' or 'disable'"
            return 1
            ;;
    esac
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    no_passwd_sudo "$@"
fi
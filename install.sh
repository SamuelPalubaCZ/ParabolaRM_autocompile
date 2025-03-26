#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# Log level
console_log_level=${console_log_levellog_level:=0}
: "
Log levels:
0 or n/none: No console output
1 or d/default: system, warn, and error messages (default)
2 or v/verbose: system, warn, error, and info messages
3 or deb/debug: All messages, including debug
"

# Remove propriaetary software (Non Working)
remove_proprietary=${remove_proprietary:=false}

# Install dependencies automatically
install_dependencies=${install_dependencies:=true}

# Package Manager detection script
pkg_detection_url=${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"}

# List of dependencies
dependencies=${dependencies:="git wget aria2"}

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}

# Remarkable kernel source URL
kernel_git=${kernel_git:="https://github.com/SamuelPalubaCZ/linux-kernel.git"}

# Remarkable kernel source branch
kernel_branch=${kernel_branch:="lars/zero-gravitas_4.9"}

# Remarkable kernel source directory
kernel_dir=${kernel_dir:="/home/user/Documents/linux-kernel"}

# Source the package manager detection variables with script by Michael Deacey (by default)
source <(wget -qO- $pkg_detection_url)
run_detection

# Install dependencies
if install_dependencies=true; then 
install_dependencies() {
    for dep in $dependencies; do
        if ! command -v $dep &> /dev/null; then
            case $pkg_manager in
                apt)
                    if previous_apt-get-update = false; then
                        sudo apt-get update
                        previous_apt-get-update=true
                    fi
                    sudo apt install $dep -y
                    ;;
                pacman)
                    sudo pacman -S $dep --noconfirm
                    ;;
                dnf)
                    sudo dnf install $dep -y
                    ;;
                zypper)
                    sudo zypper install $dep -y
                    ;;
                emerge)
                    sudo emerge $dep
                    ;;
                xbps)
                    sudo xbps-install -S $dep
                    ;;
                apk)
                    sudo apk add $dep
                    ;;
                pkg)
                    sudo pkg install $dep
                    ;;
                opkg)
                    sudo opkg install $dep
                    ;;
                *)
                    if unknown_pkg_manager = false; then
                        echo "Unknown package manager, please install next dependencies manually"
                        unknown_pkg_manager=true
                    fi
                    echo "*** $dep ***"
                    exit 1
                    ;;
            esac
        fi
    done
}
fi

#for user that dont use install_dependencies
if install_dependencies=false; then
echo "!!!MAKE SURE THAT U HAVE THESE DEPENDENCIES INSTALLED!!!
echo $dependencies
echo \n
;;


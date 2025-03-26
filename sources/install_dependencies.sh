#!/bin/bash
# Install dependencies for Remarkable kernel compile script

dir_base="/workspaces/ParabolaRM_autocompile/base.sh"
dir_download="/workspaces/ParabolaRM_autocompile/sources/download.sh"
dir_pkg_detection="/workspaces/ParabolaRM_autocompile/sources/pkg_detection.sh"
dir_download_everything="/workspaces/ParabolaRM_autocompile/sources/download_everything.sh"
dir_config="/workspaces/ParabolaRM_autocompile/config.sh
"

# Source the base.sh script
source $dir_base

# Source download.sh script
source $dir_download

# Source pkg_detection.sh script
source $dir_pkg_detection

# Source install_dependencies.sh script
source $dir_install_dependencies

sh pkg_detection.sh
package_manager=$pkg_manager  # Correct

install_dependencies() {
    dependencies="$*"
    for dep in $dependencies; do
        if ! command -v $dep &> /dev/null; then
            case "$pkg_manager" in
                apt)
                    if [ "$updated" != true ]; then
                        sudo apt-get update
                        updated=true
                    fi
                    sudo apt install "$dep" -y
                    ;;
                pacman)
                    sudo pacman -S "$dep" --noconfirm
                    ;;
                dnf)
                    sudo dnf install "$dep" -y
                    ;;
                zypper)
                    sudo zypper install "$dep" -y
                    ;;
                emerge)
                    sudo emerge "$dep"
                    ;;
                xbps)
                    sudo xbps-install -S "$dep"
                    ;;
                apk)
                    sudo apk add "$dep"
                    ;;
                pkg)
                    sudo pkg install "$dep"
                    ;;
                opkg)
                    sudo opkg install "$dep"
                    ;;
                unknown)
                    echo "Unknown package manager, please install next dependencies manually"
                    manual_pkg_manager=true
                    unknown_pkg_manager=true
                    echo "*** $dep ***"
                    ;;
            esac
        fi
    done
}
install_dependencies aria2 wget
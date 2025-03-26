#!/bin/bash
# Install dependencies for Remarkable kernel compile script

# Source the base.sh script
source base.sh
echo "Base script sourced"

# Source download.sh script
source download.sh
echo "Download script sourced"

# Source pkg_detection.sh script
source pkg_detection.sh
echo "Package detection script sourced"

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
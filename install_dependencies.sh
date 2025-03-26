#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# Source the base.sh script
source base.sh
echo "Base script sourced"

# Source download.sh script
source download.sh
echo "Download script sourced"

# Source the package manager detection variables with script by Michael Deacey (by default)
pkg_detection() {
    wget -O - ${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"} >> /tmp/pkg_detection.sh
    source /tmp/pkg_detection.sh
    run_detection
    console_log_level=${console_log_levellog_level:=0}
    echo "Package manager detection script sourced"
    echo $pkg_manager
    run_detection
}

install_dependencies() {
dependencies=${dependencies:=[$(($@))]}
    for dep in $dependencies; do
        if ! command -v $dep &> /dev/null; then
            case pkg_detection in
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
                manual)
                    if manual_pkg_manager = false; then
                        echo "Unknown package manager, please install next dependencies manually"
                    fi
                        manual_pkg_manager=true
                        unknown_pkg_manager=true
                    echo "*** $dep ***"
                    exit 1
                    ;;
                
            esac
        fi
    done
}
install_dependencies
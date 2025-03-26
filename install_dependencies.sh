#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# Source the package manager detection variables with script by Michael Deacey (by default)
pkg_detection() {
source [wget -O - ${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"}]
console_log_level=${console_log_levellog_level:=0}
: "
Log levels:
0 or n/none: No console output
1 or d/default: system, warn, and error messages (default)
2 or v/verbose: system, warn, error, and info messages
3 or deb/debug: All messages, including debug
"
run_detection
echo $pkg_manager
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

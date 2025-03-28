#!/bin/bash
echo "[PKG_DETECTION] Initializing package detection script"

package_manager() {
    echo "[PKG_DETECTION] Detecting package manager..."
    if command -v apt-get &> /dev/null; then
        echo "[PKG_DETECTION] Found apt package manager"
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "[PKG_DETECTION] Found yum package manager"
        echo "yum"
    elif command -v dnf &> /dev/null; then
        echo "[PKG_DETECTION] Found dnf package manager"
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "[PKG_DETECTION] Found pacman package manager"
        echo "pacman"
    elif command -v brew &> /dev/null; then
        echo "[PKG_DETECTION] Found brew package manager"
        echo "brew"
    elif command -v apk &> /dev/null; then
        echo "[PKG_DETECTION] Found apk package manager"
        echo "apk"
    elif command -v zypper &> /dev/null; then
        echo "[PKG_DETECTION] Found zypper package manager"
        echo "zypper"
    elif command -v emerge &> /dev/null; then
        echo "[PKG_DETECTION] Found emerge package manager"
        echo "emerge"
    else
        echo "[PKG_DETECTION] No known package manager found"
        echo "unknown"
    fi
}

pkg_manager=$(package_manager)
echo "[PKG_DETECTION] Detected package manager: $pkg_manager"
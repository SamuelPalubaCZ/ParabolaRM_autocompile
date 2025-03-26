
# Source the package manager detection variables with script by Michael Deacey (by default)
pkg_detection() {
    if [ -f /tmp/pkg_detection.sh ]; then
        rm /tmp/pkg_detection.sh
    fi
    wget -O - ${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"} >> pkg_detection.sh
    source /tmp/pkg_detection.sh
    run_detection
    console_log_level=${console_log_levellog_level:=0}
    echo "Package manager detection script sourced"
    echo $pkg_manager
}
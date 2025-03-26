dir_base="/workspaces/ParabolaRM_autocompile/base.sh"
dir_download="/workspaces/ParabolaRM_autocompile/sources/download.sh"
dir_pkg_detection="/workspaces/ParabolaRM_autocompile/sources/pkg_detection.sh"
dir_download_everything="/workspaces/ParabolaRM_autocompile/sources/download_everything.sh"
dir_config="/workspaces/ParabolaRM_autocompile/sources/config.sh
"

# Source the base.sh script
source $dir_base

# Source download.sh script
source $dir_download

# Source pkg_detection.sh script
source $dir_pkg_detection

# Source install_dependencies.sh script
source $dir_install_dependencies
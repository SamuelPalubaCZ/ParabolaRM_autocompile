# Remarkable kernel compile script for ParabolaRM distro (Parabola GNU/Linux-libre mod)

# Source the base.sh script
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
source $dir_install_dependencies
source $dir_download_everything
source $dir_extract_kernel

# Remove $kernel_dir $kernel_download_dir $toolchain_dir $toolchain_download_dir
rm -rf $kernel_dir $toolchain_dir $kernel_download_dir $toolchain_download_dir

# Install dependencies
if [ "$install_dependencies" = true ]; then
    install_dependencies $dependencies
fi

# Download everything
if [ "$download_everything" = true ]; then
    download_everything
fi

# Extract kernel
if [ "$extract_kernel" = true ]; then
    extract_kernel $kernel_dir $kernel_url
fi

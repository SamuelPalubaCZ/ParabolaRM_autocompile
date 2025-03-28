#!/bin/bash
# Download all packages that are needed for the compilation
echo "[DOWNLOAD_EVERYTHING] Initializing download_everything script"

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"
echo "[DOWNLOAD_EVERYTHING] Project root set to: $project_root"

# Source the base.sh script
echo "[DOWNLOAD_EVERYTHING] Sourcing base.sh script..."
. "${project_root}/sources/base.sh"

# Source download.sh script
echo "[DOWNLOAD_EVERYTHING] Sourcing download.sh script..."
. "${project_root}/sources/download.sh"

# Download kernel function
download_kernel() {
    echo "[DOWNLOAD_EVERYTHING] Starting kernel download from: $kernel_url"
    download $kernel_url $kernel_download_dir
    download_status=$?
    
    if [ $download_status -eq 0 ]; then
        echo "[DOWNLOAD_EVERYTHING] ✓ Kernel downloaded successfully to: $kernel_download_dir"
        # Verify files exist in the directory
        file_count=$(find "$kernel_download_dir" -type f | wc -l)
        echo "[DOWNLOAD_EVERYTHING] Files found in download directory: $file_count"
        
        if [ $file_count -eq 0 ]; then
            echo "[DOWNLOAD_EVERYTHING] ⚠️ Warning: No files found in download directory"
            return 1
        fi
    else
        echo "[DOWNLOAD_EVERYTHING] ⚠️ Kernel download failed with status: $download_status"
        return 1
    fi
    return 0
}

# Download toolchain function
download_toolchain() {
    echo "[DOWNLOAD_EVERYTHING] Starting toolchain download from: $toolchain_url"
    download $toolchain_url $toolchain_download_dir
    download_status=$?
    
    if [ $download_status -eq 0 ]; then
        echo "[DOWNLOAD_EVERYTHING] ✓ Toolchain downloaded successfully to: $toolchain_download_dir"
    else
        echo "[DOWNLOAD_EVERYTHING] ⚠️ Toolchain download failed with status: $download_status"
        return 1
    fi
    return 0
}

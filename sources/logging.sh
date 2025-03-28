#!/bin/bash
# Logging system for ParabolaRM autocompile

# Source base.sh if not already sourced
if [ -z "$project_root" ]; then
    # Set project root directory
    project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"
    
    # Source the base.sh script
    . "${project_root}/sources/base.sh"
fi

# Create logs directory if it doesn't exist
mkdir -p "$logs_dir"

# Initialize logger for a specific script
init_logger() {
    local script_name="$1"
    local caller="${2:-main}"
    local timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    local log_subdir="${logs_dir}/${script_name}"
    
    # Create script-specific log directory
    mkdir -p "$log_subdir"
    
    # Sanitize caller for use in filename (remove path)
    caller=$(basename "$caller")
    
    # Create log file with timestamp
    local log_file="${log_subdir}/${timestamp}_${caller}.log"
    
    # Write header to log file if log level is high enough
    if [ "$log_level" -ge 3 ]; then
        {
            echo "=== ParabolaRM Kernel Autocompile Log ==="
            echo "Script: $script_name"
            echo "Caller: $caller"
            echo "Time: $(date)"
            echo "User: $(whoami)"
            echo "Working Directory: $(pwd)"
            echo "Log Level: $log_level"
            echo "========================================"
            echo ""
        } > "$log_file"
    fi
    
    # Export log file path for other functions to use
    export CURRENT_LOG_FILE="$log_file"
    export CURRENT_LOG_SCRIPT="$script_name"
    
    return 0
}

# Log a message to the current log file and console based on log level
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Skip if log level is too low
    if [ "$log_level" -lt "$level" ]; then
        return 0
    fi
    
    # Format the message based on level
    local formatted_message=""
    case "$level" in
        1) formatted_message="[ERROR] $message" ;;
        2) formatted_message="[WARNING] $message" ;;
        3) formatted_message="[INFO] $message" ;;
        4) formatted_message="[DETAIL] $message" ;;
        5) formatted_message="[DEBUG] $message" ;;
        *) formatted_message="[UNKNOWN] $message" ;;
    esac
    
    # Write to log file if log level is high enough
    if [ "$log_level" -ge 3 ] && [ -n "$CURRENT_LOG_FILE" ]; then
        echo "[$timestamp]$formatted_message" >> "$CURRENT_LOG_FILE" 2>/dev/null || true
    fi
    
    # Echo to console based on log level
    if [ "$log_level" -ge 1 ]; then
        # Simplified output for level 4
        if [ "$log_level" -eq 4 ]; then
            echo "[$CURRENT_LOG_SCRIPT] $message"
        else
            case "$level" in
                1) echo "[$CURRENT_LOG_SCRIPT] ❌ $message" ;;
                2) echo "[$CURRENT_LOG_SCRIPT] ⚠️ $message" ;;
                3) echo "[$CURRENT_LOG_SCRIPT] $message" ;;
                4) echo "[$CURRENT_LOG_SCRIPT] $message" ;;
                5) echo "[$CURRENT_LOG_SCRIPT] 🔍 $message" ;;
            esac
        fi
    fi
    
    return 0
}

# Shorthand functions for different log levels
log_error() {
    log 1 "$1"
}

log_warning() {
    log 2 "$1"
}

log_info() {
    log 3 "$1"
}

log_detail() {
    log 4 "$1"
}

log_debug() {
    log 5 "$1"
}

# Log command execution and its output
log_command() {
    local cmd="$*"
    log_info "Executing command: $cmd"
    
    # Execute command and capture output
    local output
    output=$($cmd 2>&1)
    local status=$?
    
    # Log command output based on log level
    if [ "$log_level" -ge 4 ]; then
        log_detail "Command output:"
        echo "$output" >> "$CURRENT_LOG_FILE" 2>/dev/null || true
    fi
    
    # Log command status
    if [ $status -eq 0 ]; then
        log_info "Command executed successfully (status: $status)"
    else
        log_error "Command failed with status: $status"
    fi
    
    # Return the original command's exit status
    return $status
}
#!/bin/bash

# ------------------------------------------------------------------
# [Author] Script Name
#          Short description of the script's purpose
#          Example: This script starts/stops a service or configures an environment
#
# Version: 0.1.0
# Created: 03/20/2025
# ------------------------------------------------------------------

# --- Global variables ---------------------------------------------
SCRIPT_NAME=$(basename "$0")
VERSION="0.1.0"
USAGE="Usage: $SCRIPT_NAME [-h] [-v] [-p parameter]"

# --- Command-line argument parsing --------------------------------
while getopts "hvp:" opt; do
    case "$opt" in
        h)  echo "$USAGE"
            echo "  -h: Show help"
            echo "  -v: Show version"
            echo "  -p: Custom parameter (e.g., a path)"
            exit 0
            ;;
        v)  echo "Version: $VERSION"
            exit 0
            ;;
        p)  PARAMETER="$OPTARG"
            ;;
        ?)  echo "Invalid option: -$OPTARG"
            echo "$USAGE"
            exit 1
            ;;
    esac
done

# Remove processed arguments from the list
shift $((OPTIND-1))

# --- Helper functions ---------------------------------------------
# Logging function (customizable)
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Error checking function
check_error() {
    if [ $? -ne 0 ]; then
        log "ERROR: $1"
        exit 1
    fi
}

# --- Main script logic --------------------------------------------
log "Starting execution of $SCRIPT_NAME"

# Check parameter if provided
if [ -z "$PARAMETER" ]; then
    log "WARNING: Parameter -p not provided, using default value"
    PARAMETER="/opt/bitnami/default"
fi

# Example logic: Print info or perform a task
log "Parameter used: $PARAMETER"
echo "Performing main task here..."
# Add your commands here, e.g.:
# /opt/bitnami/ctlscript.sh start
# check_error "Failed to start service"

log "Finished execution of $SCRIPT_NAME"

# --- End ----------------------------------------------------------
exit 0
#!/bin/bash

# Define lib path
lib_path=$(dirname "${BASH_SOURCE[0]}")

# Remove trailing slash from lib path if it exists
lib_path="${lib_path%/}"

# Set bot_path to default path if not defined
if [ -z "$bot_path" ]; then
    # This default path is auto-generated by our release task
    bot_path="$lib_path/NotArbBot-0.0.8-alpha-jito-only"
fi

# Ensure bot_path file exists
if [ ! -f "$bot_path" ]; then
    echo "Error: bot_path file does not exist"
    exit 1
fi

# Ensure config_path is defined
if [ -z "$config_path" ]; then
    echo "Error: config_path not defined"
    exit 1
fi

# Ensure config_path file exists
if [ ! -f "$config_path" ]; then
    echo "Error: config_path file does not exist"
    echo "$config_path"
    exit 1
fi

# Java exe check
if [ -z "$java_exe_path" ]; then
    # Attempt to install Java if necessary
    . "$lib_path/install_java.sh"
else
    echo "$java_exe_path"
    "$java_exe_path" --version
    if [ $? -ne 0 ]; then
        echo "Warning: Java could not be verified."
    fi
fi

# Java vm_args check
if [ -z "$1" ]; then
    echo "Warning: No vm_args set, this is not advised."
else
    echo "vm_args=$*"
fi

# Misc debug
echo "bot_path=$bot_path"
echo "config_path=$config_path"

# Run bot
exec "$java_exe_path" --enable-preview "$@" -Dcaller_script_dir="$(pwd)" -cp "$bot_path" org.notarb.launcher.Main "$config_path"
echo "Bot exited with code $?"

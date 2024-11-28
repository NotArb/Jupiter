#!/bin/bash

# Define libs path
libs_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# The path to the bot file (required)
bot_path="$libs_path/notarb-0.1.87-alpha.jar"

# Ensure bot_path file exists
if [ ! -f "$bot_path" ]; then
    echo "Error: bot_path file does not exist"
    echo "$bot_path"
    exit 1
fi
echo "bot_path=$bot_path"

# The path to the java executable file (optional)
java_exe_path=""

# Java executable check
if [ -z "$java_exe_path" ]; then
    # Attempt to install Java if necessary
    . "$libs_path/install_java.sh"
else
    echo "$java_exe_path"
    "$java_exe_path" --version
    if [ $? -ne 0 ]; then
        echo "Warning: Java could not be verified."
    fi
fi

# Java vm_args check
if [ -z "$vm_args" ]; then
    echo "Warning: No vm_args set, this is not advised."
else
    echo "vm_args=${vm_args[@]}"
fi

# Run
exec "$java_exe_path" --enable-preview "${vm_args[@]}" -Dcaller_script_dir="$(pwd)" -cp "$bot_path" org.notarb.launcher.Main "${notarb_args[@]}"
echo "NotArb exited with code $?"

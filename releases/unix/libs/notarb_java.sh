#!/bin/bash

# Define libs path
libs_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# The path to the bot file (required)
bot_path="$libs_path/notarb-0.1.75-alpha.jar"

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
if [ -z "$1" ]; then
    echo "Warning: No vm_args set, this is not advised."
else
    echo "vm_args=$*"
fi

# Run
if [ ! -z "$jupiter_config_path" ]; then # Jupiter
  echo "Running Jupiter Management Server..."

  # Ensure $jupiter_config_path file exists
  if [ ! -f "$jupiter_config_path" ]; then
      echo "Error: jupiter_config_path file does not exist"
      echo "$jupiter_config_path"
      exit 1
  fi
  echo "jupiter_config_path=$jupiter_config_path"

  exec "$java_exe_path" --enable-preview "$@" -Dcaller_script_dir="$(pwd)" -cp "$bot_path" org.notarb.launcher.Main "--jupiter-config-path=$jupiter_config_path"
  echo "Jupiter management server exited with code $?"

elif [ ! -z "$bot_config_path" ]; then # Bot
  echo "Running Bot..."

  # Ensure config_path file exists
  if [ ! -f "$bot_config_path" ]; then
      echo "Error: bot_config_path file does not exist"
      echo "$bot_config_path"
      exit 1
  fi
  echo "bot_config_path=$bot_config_path"

  exec "$java_exe_path" --enable-preview "$@" -Dcaller_script_dir="$(pwd)" -cp "$bot_path" org.notarb.launcher.Main "--jupiter-arb-config-path=$bot_config_path"
  echo "Bot exited with code $?"

else
  echo "No config found!"
  echo "Either jupiter_config_path or bot_config_path required."
  exit 1
fi

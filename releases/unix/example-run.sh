#!/bin/bash

# The path to the bot file (optional)
export BOT_PATH=""

# The path to the bot config file (required)
export CONFIG_PATH="../example-config.toml"

# The path to the java executable file (optional)
export JAVA_EXE_PATH=""

# Source the run_bot.sh script with the specified VM arguments
. ./lib/run_bot.sh -Xmx512m

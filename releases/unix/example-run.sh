#!/bin/bash

# The path to the bot file (optional)
export bot_path=""

# The path to the bot config file (required)
export config_path="../example-config.toml"

# The path to the java executable file (optional)
export java_exe_path=""

# Source the run_bot.sh script with the specified VM arguments (https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java)
. ./lib/run_bot.sh -Xmx1024m

#!/bin/bash

# The path to the bot file (required)
export bot_path="../NotArbBot-0.1.9-alpha"

# The path to the bot config file (required)
export config_path="../temp-config.toml"

# The path to the java executable file (optional)
export java_exe_path=""

# Source the launch_bot.sh script with the specified VM arguments (https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java)
. ./launch_bot.sh -Xmx1024m

#!/bin/bash

# The path to the bot config file (required)
export bot_config_path="./bot-config.toml"

# Move to the correct workdir to prevent path issues
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the notarb_java.sh script with the specified VM arguments
# We highly recommend you increase the -Xmx value to better fit your system. Refer to other VM args here:
# https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java
. "./libs/notarb_java.sh" \
    -server \
    -Xms256m -Xmx2048m \
    -XX:+UseSerialGC
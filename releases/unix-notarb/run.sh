#!/bin/bash

# The path to the bot file (required)
export bot_path="../NotArb-0.1.16-alpha"

# The path to the bot config file (required)
export config_path="../temp-config.toml"

# The path to the java executable file (optional)
export java_exe_path=""

# Source the notarb_java.sh script with the specified VM arguments
# We highly recommend you increase the -Xmx value to better fit your system. Refer to other VM args here:
# https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java
. "$(dirname "${BASH_SOURCE[0]}")"/notarb_java.sh \
    -Xms256m -Xmx1024m \
    -XX:+UseG1GC -XX:MaxGCPauseMillis=200

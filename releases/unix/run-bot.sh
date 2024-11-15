#!/bin/bash

# The path to the bot config file (required)
BOT_CONFIG_PATH="./bot-config.toml"

# Move to the correct workdir to prevent path issues
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# We highly recommend you increase the -Xmx value to better fit your system. Refer to other VM args here:
# https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java
vm_args=( # no separating commas, each argument on a new line
  "-server"
  "-Xms256m"
  "-Xmx2048m"
  "-XX:+UseSerialGC"
)

# Args specific to running NotArb Jupiter bot
notarb_args=( # no separating commas, each argument on a new line
  "--jupiter-arb-config-path=$BOT_CONFIG_PATH"
  "--jito-uuid-example=abc" # replace "example" with something unique to identify from config file... ex: uuid="jito-uuid-example"
)

# Source the notarb_java.sh script
. "./libs/notarb_java.sh"
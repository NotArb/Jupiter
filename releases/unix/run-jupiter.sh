#!/bin/bash

# The path to the jupiter config file (required)
JUPITER_CONFIG_PATH="./jupiter-config.toml"

# Move to the correct workdir to prevent path issues
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# We highly recommend you increase the -Xmx value to better fit your system. Refer to other VM args here:
# https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java
vm_args=( # no separating commas, each argument on a new line
  "-Xmx4096m"
  "-XX:+UseSerialGC"
)

# Args specific to running NotArb Jupiter bot
notarb_args=( # no separating commas, each argument on a new line
  "--jupiter-config-path=$JUPITER_CONFIG_PATH"
)

# Source the notarb_java.sh script
. "./libs/notarb_java.sh"
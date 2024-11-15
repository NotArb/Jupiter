#!/bin/bash

# Move to the correct workdir to prevent path issues
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

vm_args=( # no separating commas, each argument on a new line
  "-Xmx512m"
)

notarb_args=( # no separating commas, each argument on a new line
  "--update-jar"
  "--libs-path=$(pwd)/../libs"
)

# Source the notarb_java.sh script
. "../libs/notarb_java.sh"
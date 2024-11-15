#!/bin/bash

KEYPAIR_PATH="/path/to/keypair.json OR /path/to/keypair.txt"

# Move to the correct workdir to prevent path issues
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

vm_args=( # no separating commas, each argument on a new line
  "-Xmx512m"
)

notarb_args=( # no separating commas, each argument on a new line
  "--protect-keypair"
  "--keypair-path=$KEYPAIR_PATH"
)

# Source the notarb_java.sh script
. "../libs/notarb_java.sh"
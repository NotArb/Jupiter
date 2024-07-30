#!/bin/bash

# Change this to use a different version of Jupiter.
# Remember if you change this url you'll need to re-run this script to build a new docker image.
# (This url must be a .zip file)
RELEASE_URL="https://github.com/jup-ag/jupiter-swap-api/releases/download/v6.0.23/jupiter-swap-api-x86_64-unknown-linux-gnu.zip"

# Ensure Docker is installed
if [ ! -x "$(command -v docker)" ]; then
    echo "Docker not installed!"
    echo "To run this script, you need to first install Docker."
    echo "Please follow the official Docker install guide below:"
    echo "https://docs.docker.com/engine/install/"
    exit 1
fi

if [ -z "$1" ]; then
    read -p "Enter absolute path to config file: " CONFIG_PATH
else
    CONFIG_PATH="$1"
fi

# Ensure config file exists in working dir
if [ ! -f "$CONFIG_PATH" ]; then
  echo "Jupiter config file not found: \"$CONFIG_PATH\""
  echo "Make sure to use an absolute path."
  exit 1
fi

echo "Starting Jupiter Docker Build..."

dockerfile_name="Dockerfile-Jupiter-Universal"

if [ -f /etc/os-release ]; then
    . /etc/os-release

    if [ "$NAME" == "Ubuntu" ]; then
        major_version=$(echo "$VERSION_ID" | cut -d'.' -f1)
        minor_version=$(echo "$VERSION_ID" | cut -d'.' -f2)

        if [ "$major_version" -ge 22 ] && [ "$minor_version" -ge 4]; then
          echo "Detected Ubuntu 22.04, using Ubuntu Dockerfile..."
          dockerfile_name="Dockerfile-Jupiter-Ubuntu"
        fi
    fi
fi

# Bring us to the "releases" dir
cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../..

# Build docker image
docker build -t jupiter-image:latest --build-arg RELEASE_URL=$RELEASE_URL \
  -f "docker/$dockerfile_name" .

# Create docker container named jupiter, but first stop/remove any existing ones
docker stop jupiter 2>/dev/null || true
docker rm jupiter 2>/dev/null || true
docker create --name jupiter --restart unless-stopped jupiter-image:latest \
  -v "$CONFIG_PATH:/jupiter/jupiter-config.toml"

# Print some useful info to the user
echo ""
echo "Build complete! You can now run your Jupiter server with the following command:"
echo "-> docker start jupiter"
echo "Here are some other useful commands:"
echo "-> docker stop jupiter"
echo "-> docker logs --follow jupiter"
echo '-> docker update --cpus="123456" jupiter'
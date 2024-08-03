#!/bin/bash

# If you want your Jupiter server to listen on a different port, change this before building.
PORT=8080

# Ensure Docker is installed
if [ ! -x "$(command -v docker)" ]; then
    echo "Docker not installed!"
    echo "To run this script, you need to first install Docker."
    echo "Please follow the official Docker install guide below:"
    echo "https://docs.docker.com/engine/install/"
    exit 1
fi

echo "Creating jupiter build image..."

# Collect all arguments to be used as jvm args
vm_args="$@"

# Check if vm_args is empty and set to default if necessary
if [ -z "$vm_args" ]; then
  echo "No vm args passed, using defaults..."
  vm_args="-Xmx512m"
fi

# Get this scripts directory
script_dir=$(dirname "${BASH_SOURCE[0]}")

# Change our dir to the one that has the NotArb file
cd "$script_dir" && cd ../

# Build docker image
docker build -t jupiter-image:latest \
  --build-arg VM_ARGS="$vm_args" \
  -f "$script_dir/Dockerfile" .

echo "Jupiter image created!"

# Create docker container named jupiter, but first stop/remove any existing ones
echo "Creating jupiter container... (port=$PORT)"
docker stop jupiter 2>/dev/null || true
docker rm jupiter 2>/dev/null || true
docker create --name jupiter --restart unless-stopped \
  -p $PORT:8080 \
  -v "$script_dir/mount:/jupiter/mount" \
  jupiter-image:latest

echo "Jupiter container created!"
echo "--------------------"

# Print some useful info to the user
echo "You can now run your Jupiter server with the following command:"
echo "-> docker start jupiter"
echo "Here are some other useful commands:"
echo "-> docker stop jupiter"
echo "-> docker logs --follow jupiter"
echo '-> docker update --cpus="123456" jupiter'
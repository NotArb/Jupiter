#!/bin/bash

detect_os_arch() {
    kernel=$(uname -s | tr '[:upper:]' '[:lower:]')

    if [[ "$kernel" == *"linux"* ]]; then
        os="linux"
    elif [[ "$kernel" == *"darwin"* ]]; then
        os="mac"
    else
        echo "Unsupported OS: $kernel"
        exit 1
    fi

    arch=$(uname -m | tr '[:upper:]' '[:lower:]')
    if [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        arch="aarch64"
    else
        arch="x64"
    fi
}

download_file() {
    local url="$1"
    local output="$2"

    if command -v wget >/dev/null 2>&1; then
        wget -O "$output" "$url"
    elif command -v curl >/dev/null 2>&1; then
        curl -o "$output" "$url"
    else
        echo "Error: Neither wget nor curl is installed."
        exit 1
    fi
}

detect_os_arch

case "$os-$arch" in
    linux-aarch64)
        java_url="https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_linux-aarch64_bin.tar.gz"
        java_exe_path="jdk-22.0.1/bin/java"
        ;;
    linux-x64)
        java_url="https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_linux-x64_bin.tar.gz"
        java_exe_path="jdk-22.0.1/bin/java"
        ;;
    mac-aarch64)
        java_url="https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_macos-aarch64_bin.tar.gz"
        java_exe_path="jdk-22.0.1.jdk/Contents/Home/bin/java"
        ;;
    mac-x64)
        java_url="https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_macos-x64_bin.tar.gz"
        java_exe_path="jdk-22.0.1.jdk/Contents/Home/bin/java"
        ;;
esac

# Define lib path
lib_path=$(dirname "${BASH_SOURCE[0]}")

# Remove trailing slash from lib path if it exists
lib_path="${lib_path%/}"

# Add lib_path to java_exe_path
java_exe_path="$lib_path/$java_exe_path"

# Download flag
download=1

# Verify existing Java executable
if [ -f "$java_exe_path" ]; then
    echo "$java_exe_path"
    "$java_exe_path" --version
    if [ $? -eq 0 ]; then
        echo "Java installation not required."
        download=0
    fi
fi

if [ $download -eq 1 ]; then
  echo "Installing Java, please wait..."
  echo "$java_url"

  # Download and extract Java
  temp_file="$lib_path/java_download_temp.tar.gz"
  download_file "$java_url" "$temp_file"
  tar -xzf "$temp_file" -C "$lib_path"
  rm -f "$temp_file"

  # Verify installed Java executable
  echo "$java_exe_path"
  "$java_exe_path" --version
  if [ $? -eq 0 ]; then
      echo "Java installation successful!"
  else
      echo "Warning: Java installation could not be verified!"
  fi
fi

export JAVA_EXE_PATH="$java_exe_path"
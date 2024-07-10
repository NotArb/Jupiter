#!/bin/bash

lib_path="$(pwd)/lib"

config_path="$(pwd)/../example_config.toml"

cd "$lib_path"
./run_bot.sh "$config_path"

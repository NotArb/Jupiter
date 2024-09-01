#!/bin/bash

ulimit -n 65535

# Optionally add whatever else you'd like, such as dynamic mint loading.
# This script will be called every time Jupiter starts/restarts, unless the
# startup_cmd is changed in the jupiter-config.toml file.
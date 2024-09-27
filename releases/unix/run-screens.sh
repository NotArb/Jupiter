#!/bin/bash

# Kill existing screens
echo "Killing existing screens..."
screen -S "notarb" -X quit || true
screen -S "jupiter" -X quit || true

# Wait a bit for the screens to terminate
sleep 1

# Start new jupiter screen
echo "Starting jupiter screen process..."
screen -dmS "jupiter"
screen -S "jupiter" -X stuff "bash ./run-jupiter.sh\n"

# Start new notarb screen
echo "Starting notarb screen process..."
screen -dmS "notarb"
screen -S "notarb" -X stuff "bash ./run-bot.sh\n"

# Print info
echo "New screen processes started, view them with:"
echo "screen -r jupiter"
echo "screen -r notarb"
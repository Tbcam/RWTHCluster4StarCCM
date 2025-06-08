#!/bin/bash

ab123=$(whoami)
ZSHRC_PATH="/home/$ab123/.zshrc"

# Download .zshrc template
curl -s https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc -o "$ZSHRC_PATH"

# Replace all occurrences of 'ab123' with your actual username
sed -i "s/ab123/$ab123/g" "$ZSHRC_PATH"

echo ".zshrc updated for user: $ab123"

#!/bin/bash

ab123=$(whoami)
ZSHRC_PATH="/home/$ab123/.zshrc"

# Download .zshrc template
curl -s https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc -o "$ZSHRC_PATH"

# Replace all occurrences of 'ab123' with your actual username
sed "s/ab123/$USER_ID/g" temp_zshrc > "$ZSHRC_PATH"

# Clean up
rm temp_zshrc

echo ".zshrc updated for user: $USER_ID"

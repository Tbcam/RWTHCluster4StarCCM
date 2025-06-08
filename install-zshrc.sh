#!/bin/bash

USER_ID=$(whoami)
ZSHRC_PATH="/home/$USER_ID/.zshrc"

curl -s https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc -o "$ZSHRC_PATH"

echo ".zshrc updated for user: $USER_ID"

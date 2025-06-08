#!/bin/bash
cd ~
curl -O https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc
MYUSER=$(whoami)
sed -i "s/ab123/$MYUSER/g" .zshrc
source ~/.zshrc

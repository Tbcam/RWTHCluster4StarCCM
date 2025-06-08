#!/bin/bash

ab123=$(whoami)
ZSHRC_PATH="/home/$ab123/.zshrc"
TEMPLATE_URL="https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc"

# Download template to a temp file for comparison
TEMP_FILE="/tmp/temp_zshrc"
curl -s "$TEMPLATE_URL" -o "$TEMP_FILE"

# Check if .zshrc exists
if [ ! -f "$ZSHRC_PATH" ]; then
    echo "No existing .zshrc file found. Creating a new one..."
    cp "$TEMP_FILE" "$ZSHRC_PATH"
else
    echo "Updating existing .zshrc without overwriting..."
    
    # Loop through each line in the template
    while IFS= read -r line; do
        # Check if line exists in current .zshrc
        if ! grep -Fxq "$line" "$ZSHRC_PATH"; then
            echo "$line" >> "$ZSHRC_PATH"
        fi
    done < "$TEMP_FILE"
fi

# Replace occurrences of 'ab123' with the actual username
sed -i "s/ab123/$ab123/g" "$ZSHRC_PATH"

# Clean up temp file
rm "$TEMP_FILE"

# Apply changes immediately
source "$ZSHRC_PATH"

echo ".zshrc updated at this path $ZSHRC_PATH and applied for user: $ab123"

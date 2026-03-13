#!/bin/bash

# Auto-updater script

# Getting the latest version from the repository
LATEST_VERSION=$(curl -s https://api.github.com/repos/noboyorg/no/releases/latest | jq -r .tag_name)

# Downloading the latest release
curl -L -o update.zip https://github.com/noboyorg/no/archive/refs/tags/$LATEST_VERSION.zip

# Unzipping the downloaded file
unzip update.zip

# Navigating to the repository folder
cd no-$LATEST_VERSION

# Assuming there's a script to install/update dependencies
if [ -f install.sh ]; then
    ./install.sh
fi

# Clean up
cd ..
rm -rf update.zip no-$LATEST_VERSION

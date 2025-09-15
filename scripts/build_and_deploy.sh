#!/bin/bash

# Exit on any error
set -e

# Constants
REPO_URL="git@github.com:linqiapp/linqiapp-flutter.git"
SSH_KEY_PATH="$ORIGINAL_DIR/../linqiapp_deploy"

# Store the current directory
ORIGINAL_DIR=$(pwd)

# Set up SSH for git operations
export GIT_SSH_COMMAND="ssh -i $SSH_KEY_PATH -o IdentitiesOnly=yes"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Function to cleanup on exit
cleanup() {
    echo "Cleaning up temporary directory..."
    cd "$ORIGINAL_DIR"
    rm -rf "$TEMP_DIR"
    unset GIT_SSH_COMMAND
}
trap cleanup EXIT

# Verify SSH key exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Error: SSH key not found at $SSH_KEY_PATH"
    exit 1
fi

# Clone the repository to temp directory
echo "Cloning repository to temporary directory..."
git clone "$REPO_URL" "$TEMP_DIR/linqiapp-flutter"
cd "$TEMP_DIR/linqiapp-flutter"

# Checkout to alpha branch
echo "Checking out alpha branch..."
git checkout alpha || { echo "Failed to checkout to alpha branch"; exit 1; }
git pull origin alpha

# Get current version from pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | cut -d"+" -f1 | cut -d":" -f2 | tr -d ' ')
echo "Current version: $VERSION"

# Split version into parts
IFS='.' read -r MAJOR MINOR SUB <<< "$VERSION"

# Increment sub version
NEW_SUB=$((SUB + 1))
NEW_VERSION="$MAJOR.$MINOR.$NEW_SUB"

# Update version in pubspec.yaml
sed -i '' "s/version: $VERSION/version: $NEW_VERSION/" pubspec.yaml
echo "Updated version to: $NEW_VERSION"

# Run update_version.sh
./scripts/update_version.sh

# Commit and push changes
echo "Committing and pushing version update..."
git add pubspec.yaml
git commit -m "chore: bump version to $NEW_VERSION"
git push origin alpha

# Run build scripts
echo "Running Android build..."
./scripts/android_build_mac_firebase.sh

echo "Running iOS build..."
./scripts/ios_build_mac_firebase.sh

echo "Build process completed successfully!"
echo "Temporary directory will be cleaned up automatically." 
#!/bin/bash

REPO_DIR="Professional-Social-Platform-Rails_Final-Project"

# Check if the directory already exists
if [ -d "$REPO_DIR" ]; then
  echo "Directory '$REPO_DIR' already exists. Performing git pull."
  cd "$REPO_DIR"
  git pull
else
  # Directory doesn't exist, so clone the repository
  echo "Cloning the repository..."
  git clone https://github.com/satrujit-kreeti/Professional-Social-Platform-Rails_Final-Project.git "$REPO_DIR"
  cd "$REPO_DIR"
fi

# Check if the git operation was successful
if [ $? -ne 0 ]; then
  echo "Error: Git operation failed."
  exit 1
fi

# Run bin/setup
echo "== Running bin/setup =="
bin/setup

# Check if bin/setup was successful
if [ $? -ne 0 ]; then
  echo "Error: bin/setup failed."
  exit 1
fi

# Run bin/dev
echo "== Running bin/dev =="
bin/dev

# Check if bin/dev was successful
if [ $? -ne 0 ]; then
  echo "Error: bin/dev failed."
  exit 1
fi

echo "== Script completed successfully =="

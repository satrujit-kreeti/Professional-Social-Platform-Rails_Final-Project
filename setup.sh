#!/bin/bash

# Clone the repository
echo "== Cloning the repository =="
git clone https://github.com/satrujit-kreeti/Professional-Social-Platform-Rails_Final-Project.git
cd Professional-Social-Platform-Rails_Final-Project

# Check if git clone was successful
if [ $? -ne 0 ]; then
  echo "Error: Git clone failed."
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

#!/bin/bash

# Get the list of changed package.json files
CHANGED_FILES=$(git diff --name-only ${{ github.event.before }} ${{ github.sha }} | grep 'packages/pieces/.*/package.json')

# Loop through the changed files
for file in $CHANGED_FILES
do
  # Extract the piece name
  piece=$(echo $file | sed -n 's|packages/pieces/\(.*\)/package.json|\1|p')

  echo "Checking file: $file"
  echo "Piece: $piece"

  # Check if the version number has changed
  if git diff ${{ github.event.before }} ${{ github.sha }} -- $file | grep '"version":'
  then
    echo "Running..."
    # Run the publishing command for the piece
    npm run publish-piece $piece
  fi
done
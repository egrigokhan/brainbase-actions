#!/bin/bash

# Get the list of changed package.json files
CHANGED_FILES=$(git diff --name-only $GITHUB_BEFORE $GITHUB_SHA | grep 'packages/pieces/.*/package.json')

# Loop through the changed files
for file in $CHANGED_FILES
do
  # Extract the piece name
  piece=$(echo $file | sed -n 's|packages/pieces/\(.*\)/package.json|\1|p')

  # Check if the version number has changed
  if git diff $GITHUB_BEFORE $GITHUB_SHA -- $file | grep '"version":'
  then
    # Run the publishing command for the piece
    npm run publish-piece $piece
  fi
done

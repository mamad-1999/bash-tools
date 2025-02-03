#!/bin/bash

# Banner
echo ""
echo "██████╗ ███████╗████████╗    ██████╗  █████╗ ███████╗████████╗"
echo "██╔════╝ ██╔════╝╚══██╔══╝   ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
echo "██║  ███╗█████╗     ██║      ██████╔╝███████║█████╗     ██║"
echo "██║   ██║██╔══╝     ██║      ██╔══██╗██╔══██║██╔══╝     ██║"
echo "╚██████╔╝███████╗   ██║      ██║  ██║██║  ██║██║        ██║"   
echo " ╚═════╝ ╚══════╝   ╚═╝      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝"  
echo ""

# Define the base URL and the list of files to download
BASE_URL="https://raw.githubusercontent.com/danielmiessler/SecLists/refs/heads/master/Discovery/Web-Content"
FILES=(
  "raft-medium-files.txt"
  "raft-medium-directories.txt"
  "raft-medium-words.txt"
  "raft-medium-extensions.txt"
  "raft-large-files.txt"
  "raft-large-directories.txt"
  "raft-large-words.txt"
  "raft-large-extensions.txt"
  "raft-small-files.txt"
  "raft-small-directories.txt"
  "raft-small-words.txt"
  "raft-small-extensions.txt"
)

# Loop through the files and download them if they don't exist
for file in "${FILES[@]}"; do
  if [[ -f "$file" ]]; then
    echo "File '$file' already exists."
  else
    echo "Downloading '$file'..."
    curl -s -o "$file" "$BASE_URL/$file"
    if [[ $? -eq 0 ]]; then
      echo "Downloaded '$file' successfully."
    else
      echo "Failed to download '$file'."
    fi
  fi
done

echo "All files downloaded."


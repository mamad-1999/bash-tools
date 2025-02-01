#!/bin/bash

# Check for required arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <parent-folder> <tree-file>"
    exit 1
fi

parent_dir="$1"
tree_file="$2"

# Create parent directory if it doesn't exist
mkdir -p "$parent_dir"

declare -a depth_levels
depth_levels[0]="$parent_dir"

while IFS= read -r line; do
    # Skip lines that don't contain tree structure
    if [[ "$line" =~ ^(.*)(├|└)──[[:space:]]+(.*) ]]; then
        indentation="${BASH_REMATCH[1]}"
        entry="${BASH_REMATCH[3]}"
        
        # Trim whitespace from entry
        entry="$(echo -e "${entry}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        
        # Calculate depth based on indentation (4 characters per level)
        indent_length=${#indentation}
        depth=$((indent_length / 4))
        
        # Verify valid depth
        if [[ -z "${depth_levels[$depth]}" ]]; then
            echo "Error: Invalid tree structure at line: $line"
            exit 1
        fi

        parent="${depth_levels[$depth]}"
        
        if [[ "$entry" == */ ]]; then
            # Directory processing
            dir_name="${entry%/}"
            full_path="$parent/$dir_name"
            echo "Creating directory: $full_path"
            mkdir -p "$full_path"
            # Update depth level for next items
            depth_levels[$((depth + 1))]="$full_path"
        else
            # File processing
            full_path="$parent/$entry"
            echo "Creating file: $full_path"
            touch "$full_path"
        fi
    fi
done < "$tree_file"

echo "Structure created successfully in: $parent_dir"

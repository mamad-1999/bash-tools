#!/bin/bash

output_file="project_summary.txt"

show_help() {
    echo "Usage: $0 PROJECT_ROOT [--exclude PATTERNS] [-h]"
    echo "Generate a summary of the project structure and file contents."
    echo ""
    echo "Arguments:"
    echo "  PROJECT_ROOT          Path to the project directory"
    echo "Options:"
    echo "  --exclude PATTERNS    Comma or space-separated patterns to exclude"
    echo "  -h                    Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 /path/to/project --exclude .git,node_modules"
}

is_excluded() {
    local path="$1"
    for pattern in "${exclude[@]}"; do
        if [[ "$path" == *"$pattern"* ]]; then
            return 0
        fi
    done
    return 1
}

process_file() {
    local file="$1"
    local relative_path="$2"
    local filename=$(basename "$file")

    if is_excluded "$relative_path"; then
        return
    fi

    if file -b --mime-type "$file" | grep -q 'text/'; then
        lines=$(wc -l < "$file")
        echo -e "\n$filename (lines: $lines):" >> "$output_file"
        cat "$file" >> "$output_file"
        echo >> "$output_file"
    else
        echo -e "\n$filename [Binary or non-text file skipped]" >> "$output_file"
    fi
}

process_directory() {
    local dir="$1"
    local relative_dir="$2"

    if is_excluded "$relative_dir"; then
        return
    fi

    if [[ "$relative_dir" == "." ]]; then
        echo "Project Root" >> "$output_file"
    else
        echo "${relative_dir} folder" >> "$output_file"
    fi

    shopt -s nullglob
    for file in "$dir"/*; do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local file_relative_path="${relative_dir}/${filename}"
            process_file "$file" "$file_relative_path"
        fi
    done

    for subdir in "$dir"/*; do
        if [[ -d "$subdir" && ! -L "$subdir" ]]; then
            local subdir_name=$(basename "$subdir")
            local subdir_relative_path="${relative_dir}/${subdir_name}"
            process_directory "$subdir" "$subdir_relative_path"
        fi
    done
    shopt -u nullglob
}

# Parse arguments
project_root=""
exclude=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --exclude)
            shift
            IFS=', ' read -ra patterns <<< "$1"
            exclude+=("${patterns[@]}")
            shift
            ;;
        *)
            if [[ -z "$project_root" ]]; then
                project_root="$1"
                shift
            else
                echo "Error: Unexpected argument $1" >&2
                show_help
                exit 1
            fi
            ;;
    esac
done

if [[ -z "$project_root" ]]; then
    echo "Error: Project root directory is required" >&2
    show_help
    exit 1
fi

project_root=$(realpath "$project_root")

if [[ ! -d "$project_root" ]]; then
    echo "Error: $project_root is not a valid directory" >&2
    exit 1
fi

shopt -s dotglob
: > "$output_file"
process_directory "$project_root" "."
shopt -u dotglob

echo "Project structure and content have been written to $output_file"

#!/bin/bash

# Version: 1.1
# Author: Your Name
# Description: Twitter media downloader with proxy support

show_help() {
    cat <<EOF
Usage: $0 [OPTIONS] <twitter-url>

Options:
  -h, --help          Show this help message and exit
  --proxy <proxy_url> Use specified proxy (e.g. http://proxy:port or socks5://user:pass@host:port)

Examples:
  $0 "https://twitter.com/user/status/1234567890"
  $0 --proxy http://myproxy:8080 "https://x.com/user/status/1234567890"
EOF
}

# Check dependencies
check_deps() {
    local missing=()
    command -v jq &>/dev/null || missing+=("jq")
    command -v curl &>/dev/null || missing+=("curl")
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[*]}"
        echo "Install with:"
        [ -n "$(command -v apt-get)" ] && echo "  sudo apt-get install ${missing[*]}"
        [ -n "$(command -v brew)" ] && echo "  brew install ${missing[*]}"
        exit 1
    fi
}

# Main script
parse_arguments() {
    proxy=""
    url=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            --proxy)
                if [ -z "$2" ]; then
                    echo "Error: --proxy requires a value"
                    exit 1
                fi
                proxy="$2"
                shift 2
                ;;
            *)
                if [[ "$1" == http* ]]; then
                    url="$1"
                    shift
                else
                    echo "Error: Invalid argument '$1'"
                    show_help
                    exit 1
                fi
                ;;
        esac
    done

    if [ -z "$url" ]; then
        echo "Error: Twitter URL required"
        show_help
        exit 1
    fi
}

# Function to extract tweet IDs from URL
extract_tweet_ids() {
    echo "$1" | grep -Eo '(twitter\.com|x\.com)/[^/]+/(status|statuses)/([0-9]+)' | grep -Eo '[0-9]+$'
}

# Sanitize filenames
sanitize_filename() {
    echo "$1" | sed 's/[<>:"\/\\|?*]//g' | cut -c -200
}

# Build curl command with optional proxy
curl_cmd() {
    local cmd=(curl -s --insecure)
    [ -n "$proxy" ] && cmd+=(--proxy "$proxy")
    cmd+=("$@")
    "${cmd[@]}"
}

# Main execution
check_deps
parse_arguments "$@"
mkdir -p downloads

tweet_ids=$(extract_tweet_ids "$url")
if [[ -z "$tweet_ids" ]]; then
    echo "No valid tweet IDs found in URL"
    exit 1
fi

success=false
for tweet_id in $tweet_ids; do
    echo "Processing tweet ID: $tweet_id"
    
    api_url="https://api.vxtwitter.com/Twitter/status/$tweet_id"
    response=$(curl_cmd "$api_url")
    
    media_count=$(echo "$response" | jq '.media_extended | length')
    
    for i in $(seq 0 $((media_count - 1))); do
        media=$(echo "$response" | jq ".media_extended[$i]")
        media_url=$(echo "$media" | jq -r '.url')
        type=$(echo "$media" | jq -r '.type')
        
        ext=".jpg"
        [[ "$type" == "video" ]] && ext=".mp4"
        
        filename=$(sanitize_filename "tweet_${tweet_id}_${i}${ext}")
        save_path="downloads/$filename"
        
        echo "Downloading: $filename"
        if curl_cmd -L -# "$media_url" -o "$save_path"; then
            echo "Successfully downloaded: $filename"
            success=true
        else
            echo "Failed to download: $filename"
            rm -f "$save_path" 2>/dev/null
        fi
    done
done

if $success; then
    echo "Downloads completed successfully"
    exit 0
else
    echo "No media downloaded"
    exit 1
fi

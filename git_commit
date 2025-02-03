git-commit() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: git-commit <type> <message>"
        return 1
    fi

    local commit_type=$1
    local commit_message=$2

    git pull
    git add .
    git commit -m "$commit_type: $commit_message"
}

# Usage: git-commit "style" "change some style"
# Output in gitlog: style: change some style

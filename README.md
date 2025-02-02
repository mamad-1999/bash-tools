# Scripts Documentation

## `copy_project.sh`

**Usage**:  
Generates project structure summary with file contents.

This is useful when you want to explain your project for Ai.
```bash
./copy_project.sh PROJECT_ROOT [--exclude PATTERNS]
# Example: 
./copy_project.sh /path/to/project --exclude .git,node_modules
```
---

## `git_commit.sh`

**Usage**:  
Simplifies Git commits (first pull,fetch) with type prefixes.  
```bash
git-commit <type> <message>
# Example: 
git-commit "style" "change some style"
# Output commit message: "style: change some style"
```

---

## `raft_downloader.sh`

**Usage**:  
Downloads Raft wordlist files from SecLists repository.

This script downloads all Raft wordlist (large,medium,small)

```bash
./raft_downloader.sh
# Automatically checks for existing files and skips duplicates
```

---

## `tree-to-fs.sh`

**Usage**:  
Converts tree structure descriptions to actual files/folders.

Create folder and files from this format:
```bash
├── .env 
├── .env.example 
├── .github/ 
│   └── workflows/ 
│       └── writeup-finder-runner.yml 
├── .gitignore 
├── CHANGELOG.md 
├── LICENSE 
├── README.md 
├── command/ 
│   ├── action.go 
│   ├── command.go 
│   ├── completion.go 
│   └── flags.go 
├── data/ 
│   ├── Youtube_channel.md 
│   ├── keywords.json 
│   └── url.txt 
├── db/ 
│   ├── db.go 
│   └── db_test.go 
├── global/ 
│   └── global.go 
├── go.mod 
├── go.sum 
├── handler/ 
│   ├── handler.go 
│   ├── medium.go 
│   ├── utils.go 
│   └── youtube.go 
├── main.go 
├── run_writeUp-finder.sh 
├── telegram/ 
│   ├── message.go 
│   ├── proxy.go 
│   ├── request.go 
│   └── telegram.go 
├── utils/ 
│   ├── env.go 
│   ├── filters.go 
│   ├── http.go 
│   ├── rss.go 
│   └── utils.go 
└── writeup-finder
```
and
Result is:

![2025-02-02_16-15](https://github.com/user-attachments/assets/3356a537-6ccd-4451-bf90-1eeda26aefed)


```bash
./tree-to-fs.sh <parent-folder-name> <file-include-tree>

# Example: 
./tree-to-fs.sh my_project project_tree.txt
```

---

## `notify-me`

**Usage**:  
Alarm/reminder tool with desktop notifications and sound.

Should use with `nohup` and `&`
```bash
notify-me [HH:MM] "message"

# Examples:
notify-me 14:30 "Go to the gym"
notify-me --proxy http://myproxy:8080 "https://x.com/user/status/1234567890"
```

---

## `twitter_downloader.sh`

**Usage**:  
Downloads media from Twitter/X URLs with proxy support.  
```bash
./twitter_downloader.sh [--proxy PROXY_URL] <twitter-url>

# Example:
./twitter_downloader.sh --proxy http://myproxy:8080 "https://x.com/user/status/1234567890"

# Requires: curl, jq
```

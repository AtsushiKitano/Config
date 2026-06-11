#!/bin/bash
set -uo pipefail

ORG_DIR="${HOME}/org"
LOG_DIR="${HOME}/.local/log"
LOG_FILE="${LOG_DIR}/org-sync.log"
BRANCH="main"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

cd "$ORG_DIR" || { log "ERROR: Cannot cd to $ORG_DIR"; exit 1; }

# ローカルの変更をコミット
git add -A

if git diff --cached --quiet; then
    log "No local changes"
else
    COMMIT_MSG="auto sync: $(date '+%Y-%m-%d %H:%M')"
    if git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1; then
        log "Committed: $COMMIT_MSG"
    else
        log "ERROR: Commit failed"
        exit 1
    fi
fi

# リモートと同期
if git pull --rebase origin "$BRANCH" >> "$LOG_FILE" 2>&1; then
    if git push origin "$BRANCH" >> "$LOG_FILE" 2>&1; then
        log "Sync complete"
    else
        log "ERROR: Push failed"
        exit 1
    fi
else
    log "ERROR: Pull --rebase failed (conflict?). Manual intervention needed."
    git rebase --abort >> "$LOG_FILE" 2>&1 || true
    exit 1
fi

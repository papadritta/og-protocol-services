#!/bin/bash

SOURCE_DIR="$HOME/.0gchain"
BACKUP_DIR="$HOME/0gchain_backup"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory $SOURCE_DIR does not exist."
    exit 1
fi

if [ -d "$BACKUP_DIR" ]; then
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    echo "Warning: Backup directory $BACKUP_DIR already exists with a size of $BACKUP_SIZE."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

rsync -av --progress --exclude 'data' "$SOURCE_DIR/" "$BACKUP_DIR/"

mkdir -p "$BACKUP_DIR/data"

cp "$SOURCE_DIR/data/priv_validator_state.json" "$BACKUP_DIR/data/"

echo "Backup completed successfully. You saved all OG node info in $HOME/0gchain_backup"

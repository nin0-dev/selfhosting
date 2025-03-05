#!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
    exit 1
fi

for file in $(rclone lsf iCloud:Backup/); do
    if [[ $file != $1 ]]; then
        rclone delete iCloud:Backup/$1
    fi
done
#!/usr/bin/env bash
_() {
    cd stacks/$1
    volumes=$(yq e '.services[].volumes[]' compose.yaml | grep -oP '^\S+(?=:)' | sort -u) # i love AI
    for volume in $volumes; do
        mkdir -p "$volume"
    done
    if [ -f .env.example ] && [ ! -f .env ]; then
        (cd ../../ && sht env $1)
    fi
    docker compose up -d
} && _ "$@"
unset -f _

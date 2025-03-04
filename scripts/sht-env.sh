#!/usr/bin/env bash
if [ -f "stacks/$1/.env.example" ] && [ ! -f "stacks/$1/.env" ]; then
  cp "stacks/$1/.env.example" "stacks/$1/.env"
elif [ ! -f "stacks/$1/.env.example" ]; then
  echo "what"
  exit 1
fi
${EDITOR:-nano} "stacks/$1/.env"
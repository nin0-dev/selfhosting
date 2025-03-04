#!/usr/bin/env bash
_() {
  cd stacks/$1
  docker compose down
  docker compose up -d
} && _ "$@"
unset -f _

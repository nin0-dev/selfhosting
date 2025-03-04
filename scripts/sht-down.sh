#!/usr/bin/env bash
_() {
  cd stacks/$1
  docker compose down
} && _ "$@"
unset -f _

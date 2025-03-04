#!/bin/bash
_() {
  cd stacks/$1
  docker compose up -d
} && _ "$@"
unset -f _

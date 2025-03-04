#!/usr/bin/env bash
_() {
  cd stacks/$1
  docker compose logs
} && _ "$@"
unset -f _
#!/usr/bin/env bash
_() {
  cd stacks/$1
  docker compose ps --format "table {{.ID}}\t{{.Service}}\t{{.Status}}\t{{.Ports}}"
} && _ "$@"
unset -f _
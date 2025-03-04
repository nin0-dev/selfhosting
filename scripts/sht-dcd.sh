#!/usr/bin/env bash
_() {
  if [ -z "data/$1" ]; then
    echo "what"
    return 1
  fi
  echo "You are now in an ephemeral shell in the data directory for $1."
  cd data/$1
  bash
} && _ "$@"
unset -f _
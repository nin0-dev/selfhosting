#!/usr/bin/env bash
_() {
  if [ -z "stacks/$1" ]; then
    echo "what"
    return 1
  fi
  echo "You are now in the $1 directory."
  cd stacks/$1
} && _ "$@"
unset -f _
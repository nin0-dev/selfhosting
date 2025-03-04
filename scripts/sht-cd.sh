#!/usr/bin/env bash
if [ -z "stacks/$1" ]; then
  echo "what"
  return 1
fi
echo "You are now in the $1 directory in an ephemeral shell."
bash -c "cd stacks/$1; exec bash"
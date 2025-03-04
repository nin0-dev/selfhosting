#!/bin/bash
_() {
  if [ $# -eq 0 ]; then
    git pull
    for stack in stacks/* ; do
    if ! yq e '.services[].image' "$stack/compose.yaml" | grep -Eq ':(latest|stable)'; then
      IMAGE=`yq e '.services[].image' "$stack/compose.yaml"`
      echo -e "\033[1;33mwarning: $IMAGE may be pinned to a specific version.\033[0m"
       fi
      (cd $stack && docker compose pull)
    done
  elif [ "$1" == "git" ]; then
    git pull
  elif [ "$1" == "pull" ]; then
    for stack in stacks/* ; do
      (cd $stack && docker compose pull)
    done
  else
    echo "what"
fi
  } && _ "$@"
direnv allow
unset -f _


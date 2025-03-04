#!/usr/bin/env bash
docker_pull() {
  for stack in stacks/* ; do
    if [ -f $stack/.env.example ] && [ ! -f $stack/.env ]; then
        touch $stack/.env # needed else docker shits itself
    fi
    if ! yq e '.services[].image' "$stack/compose.yaml" | grep -Eq ':(latest|stable)'; then
      IMAGE=`yq e '.services[].image' "$stack/compose.yaml" | tr '\n' ','`
      echo -e "\033[1;33mwarning: $IMAGE may be pinned to a specific version.\033[0m"
       fi
      (cd $stack && docker compose pull)
  done
}

_() {
  if [ $# -eq 0 ]; then
    git pull
    docker_pull
  elif [ "$1" == "git" ]; then
    git pull
  elif [ "$1" == "pull" ]; then
    docker_pull
  else
    echo "what"
fi
  } && _ "$@"
direnv allow
unset -f _
unset -f docker_pull

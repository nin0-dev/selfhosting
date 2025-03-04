#!/usr/bin/env bash
for stack in stacks/*; do
    stack_name=$(basename "$stack")
    echo "Stop $stack_name"
    scripts/sht-down.sh "$stack_name" &
done

wait

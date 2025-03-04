#!/bin/bash
for stack in stacks/*; do
    stack_name=$(basename "$stack")
    echo "Starting $stack_name"
    scripts/sht-start.sh "$stack_name" &
done

wait

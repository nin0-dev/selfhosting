#!/bin/bash
for stack in stacks/*; do
    stack_name=$(basename "$stack")
    echo "Stop $stack_name"
    scripts/sht-stop.sh "$stack_name" &
done

wait

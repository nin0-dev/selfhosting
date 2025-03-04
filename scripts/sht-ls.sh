#!/bin/bash
for stack in stacks/*; do
    stack_name=$(basename "$stack")
    scripts/sht-info.sh $stack_name
done

wait

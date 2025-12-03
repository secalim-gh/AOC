#!/bin/bash

joltage=0

while IFS= read -r line; do
    max=0 
    power=$(($2 - 1))
    len=$((${#line}-$power))
    k=0
    # Save biggest n from 0 to len minus the number of batteries
    while ((power >= 0)); do
        for ((i=k; i < len; i++)); do
            d=(${line:i:1})

            if (( d > max )); then
                k=$i
                max=$d
            fi
        done
        joltage=$((joltage + max*(10**power)))
        power=$(($power-1))
        len=$((${#line}-$power))
        k=$((k+1))
        max=0
    done
done < "$1"

echo "joltage: $joltage"

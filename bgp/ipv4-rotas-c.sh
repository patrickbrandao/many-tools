#!/bin/sh

for a in $(seq 0 1 223); do
    for b in $(seq 0 1 255); do
	for c in $(seq 0 1 255); do
	    echo "$a.$b.$c.0/24"
	done
    done
done


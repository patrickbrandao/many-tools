#!/bin/sh

for a in $(seq 0 1 223); do
    for b in $(seq 0 1 255); do
	echo "$a.$b.0.0/16"
    done
done


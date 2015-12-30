#!/bin/sh

for a in $(seq 0 1 223); do
    for b in $(seq 0 1 255); do
	for p in 0 64 128 192; do
		echo "$a.$b.$p.0/18"
	done
    done
done

#!/bin/sh

for a in $(seq 0 1 223); do
    for b in $(seq 0 1 255); do
    	for p in $(seq 0 8 252); do
    		echo "$a.$b.$p.0/21"
    	done
    done
done

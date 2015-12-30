#!/bin/sh

for a in $(seq 0 1 223); do
  for b in $(seq 0 1 255); do
	    for c in $(seq 0 1 255); do
	      for p in $(seq 0 4 252); do
		      echo "$a.$b.$c.$p/22"
	      done
	    done
  done
done

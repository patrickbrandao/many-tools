#!/bin/sh

for a in $(seq 0 1 223); do
  for b in $(seq 0 1 255); do
    for p in 0 32 64 96 128 160 192 224; do
      echo "$a.$b.$p.0/19"
    done
  done
done


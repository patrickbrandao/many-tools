#!/bin/sh

for a in $(seq 0 1 223); do
	echo "$a.0.0.0/8"
done


#!/bin/sh

PROC="${PROC:-1}"

for i in $(seq 1 $PROC); do
    /bin/sh -c 'while true; do :; done' &
done

wait
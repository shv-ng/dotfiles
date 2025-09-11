#!/bin/bash

INTERVAL=2700

while true; do
  notify-send -u normal "Time to take a break"
  sleep $INTERVAL
done



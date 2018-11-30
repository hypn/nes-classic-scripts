#!/bin/bash
echo "Running ffmpeg for $1"
./ffmpeg -i $1 -pix_fmt bgra -f fbdev /dev/fb0

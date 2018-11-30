#!/bin/bash
echo "Running decodepng for $1"
./decodepng $1 > /dev/fb0;

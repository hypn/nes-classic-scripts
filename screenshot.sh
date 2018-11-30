#!/bin/bash
rm screenshot.jpg 2>/dev/null
./ffmpeg -f fbdev -framerate 1 -i /dev/fb0 -frames:v 1 screenshot.jpg

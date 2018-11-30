#!/bin/bash

# Returns true if the emulator is in CRT mode

CRT_OFFSET="0x00066bfc" # or 0x00001405?

(./read-offset.sh $CRT_OFFSET | grep 00 -q) && echo true || echo false

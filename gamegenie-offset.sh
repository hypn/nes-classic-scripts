#!/bin/bash

# Converts a GameGenie offset to the correct NES Classic offset

if [[ "$#" -ne 1 ]]; then
  echo "Usage:"
  echo "  $0 <offset in hex>"
  echo
  exit 1
fi

# CRT_MODE=`./is-crt-mode.sh`
# if [ $CRT_MODE = "true" ]
# then
# 	# "CRT" OFFSET:
# 	ROM_OFFSET="0x000BD700"
# else
# 	# "4:3" and "Pixel Perfect" OFFSET:
# 	ROM_OFFSET="0x00134780"
# fi

ROM_OFFSET="`./get-rom-offset.sh`"

ROM_OFFSET_HEX=`printf "%d" $ROM_OFFSET`
HEADER_OFFSET="16"                                    # 0x10 = size of .nes rom header
OFFSET=`printf "%d" $1`                               # convert GameGenie offset to decimal

# handle GameGenieDecode returning addresses that are too high
if [[ $OFFSET -gt 32768 ]]; then
  OFFSET=$(($OFFSET - 32768))
fi

ADDRESS=$(($ROM_OFFSET + $HEADER_OFFSET + $OFFSET))   # add up all the offsets
ADDRESS_HEX="$(printf "0x%x" $ADDRESS)"               # convert final address back to hex

# DEBUG:
# echo "Full offset: $ADDRESS_HEX (`printf "0x%x" $ROM_OFFSET` + `printf "0x%x" $HEADER_OFFSET` + $1)"

echo $ADDRESS_HEX

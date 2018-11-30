#!/bin/bash

# videos used below are from https://hackerscurator.com/

PREV_MUSHROOM="00"

while true; do

  ROM_OFFSET="`./get-rom-offset.sh`"
  if [[ $? -ne 0 ]]; then
    echo "NES emulator or ROM header not found..."
    sleep 2

  else
    # calcuate the mushroom offset (for CRT/non-CRT) from coin offset
    ROM_OFFSET_DEC=`printf "%d" $ROM_OFFSET`
    COINS_OFFSET=`printf "0x%x" $(($ROM_OFFSET_DEC - 140546))`
    CRT_MODE=`./is-crt-mode.sh`
    if [ $CRT_MODE = "true" ]; then
      COINS_OFFSET=$(($COINS_OFFSET + 56))
    fi
    MUSHROOM_OFFSET=`printf "0x%x"  $(($COINS_OFFSET - 8))`

    MUSHROOM=`./read-offset.sh $MUSHROOM_OFFSET`
    if [ $? -eq 0 ]; then

      if [ "$MUSHROOM" -ne "$PREV_MUSHROOM" ]; then
        PREV_MUSHROOM=$MUSHROOM
        kill -STOP `pgrep kachikachi`   # pause emulator

        if [ "$MUSHROOM" = "01" ]; then
          sleep .1
          ./ffmpeg -i ./Crash_Override.mp4 -pix_fmt bgra -f fbdev /dev/fb0

        elif [ "$MUSHROOM" = "02" ]; then
          sleep .1
          ./ffmpeg -i ./Acid_Burn.mp4 -pix_fmt bgra -f fbdev /dev/fb0
        fi

        kill -CONT `pgrep kachikachi`   # resume emulator
      fi
    fi
  fi
done

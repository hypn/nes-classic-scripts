#!/bin/bash
echo

# Outputs some info about Super Mario Bros 1

ROM_OFFSET="`./get-rom-offset.sh`"
if [[ $? -ne 0 ]]; then
  echo "$ROM_OFFSET"
  exit 1
fi

ROM_OFFSET_DEC=`printf "%d" $ROM_OFFSET`

# offset are calculated back from the "NES" header (so we subtract the required number of bytes)
COINS_OFFSET=`printf "0x%x" $(($ROM_OFFSET_DEC - 140546))`

# in CRT mode the offsets are another 56 bytes closer to the "NES" header
CRT_MODE=`./is-crt-mode.sh`
if [ $CRT_MODE = "true" ]; then
  COINS_OFFSET=$(($COINS_OFFSET + 56))
fi

# Other offsets calculated from the offset for coins
LIVES_OFFSET=`printf "0x%x"     $(($COINS_OFFSET - 4))`
MUSHROOM_OFFSET=`printf "0x%x"  $(($COINS_OFFSET - 8))`
LEVEL_OFFSET=`printf "0x%x"     $(($COINS_OFFSET + 41239))`
WORLD_OFFSET=`printf "0x%x"     $(($COINS_OFFSET + 41237))`

COINS="`./read-offset.sh $COINS_OFFSET`"
MUSHROOM="`./read-offset.sh $MUSHROOM_OFFSET`"
WORLD="`./read-offset.sh $WORLD_OFFSET`"
LEVEL="`./read-offset.sh $LEVEL_OFFSET`"
LIVES=$((`./read-offset.sh $LIVES_OFFSET` + 1))

COINS="`printf "%d\n" 0x$COINS`"
WORLD="`printf "%d\n" 0x$WORLD`"
LEVEL="`printf "%d\n" 0x$LEVEL`"
LIVES="`printf "%d\n" 0x$LIVES`"

if [ "$MUSHROOM" = "02" ]
then
  MUSHROOM="fire"
elif [ "$MUSHROOM" = "01" ]
then
  MUSHROOM="big"
else
  MUSHROOM="small"
fi

echo "  Lives: $LIVES"
echo "  Coins: $COINS"
echo "  Level: $WORLD-$LEVEL"
echo "  Mario: $MUSHROOM"

echo

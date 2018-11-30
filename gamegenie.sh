#!/bin/bash

# Applies a GameGenie code to the running game

ROM_OFFSET="`./get-rom-offset.sh`"
ROM_OFFSET_DEC="`printf "%d" $ROM_OFFSET`"

if [[ "$#" -ne 2 ]]; then
  if [[ "$#" -eq 1 && $1 != 0x* ]]; then
    DECODED="`./GameGenieDecoder $1`"

    if [[ $? -ne 0 ]]; then
      echo "$DECODED"
      exit 1
    else
      OFFSET="`./gamegenie-offset.sh $(echo $DECODED | awk '{print $1}')`"
      BYTE=`echo "$DECODED" | awk '{print $2}')`
      UNDO_OFFSET=$(($OFFSET - $ROM_OFFSET_DEC - 16))
    fi

  else
    echo "Usage:"
    echo "  $0 <gamegenie code>"
    echo "    OR"
    echo "  $0 <offset in hex> <byte hexcode>"
    echo
    exit 1
  fi
else
  OFFSET="`./gamegenie-offset.sh $1`"
  BYTE="${2/0x/}"
  UNDO_OFFSET=$1
fi


UNDO_OFFSET=`printf "%08x" $UNDO_OFFSET`

# DEBUG:
# echo "Offset: $OFFSET, Byte: $BYTE"

BYTE_WAS="`./read-offset.sh $OFFSET`"
./write-offset.sh $OFFSET $BYTE
BYTE_IS="`./read-offset.sh $OFFSET`"

if [ "$BYTE_WAS" != "$BYTE_IS" ]; then
  echo "Byte at $OFFSET changed from \"$BYTE_WAS\" to \"$BYTE_IS\""
  echo "Undo with: $0 0x$UNDO_OFFSET $BYTE_WAS"
else
  echo 'No change made! (already patched?)'
fi

echo

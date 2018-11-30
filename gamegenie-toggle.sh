#!/bin/bash

if [[ "$#" -ne 3 ]]; then
  echo "Usage:"
  echo "  $0 <gamegenie_address> <original_byte> <gamegenie_byte>"
  echo
  exit 1
fi

GAMEGENIE_OFFSET=$1
ORIGINAL_BYTE=$2
GAMEGENIE_BYTE=$3

# get current byte at (actual) offset
OFFSET="`./gamegenie-offset.sh $GAMEGENIE_OFFSET`"
CURRENT_BYTE="`./read-offset.sh $OFFSET`"

if [ "$CURRENT_BYTE" = "$ORIGINAL_BYTE" ]; then
	RESULT="`./gamegenie.sh $GAMEGENIE_OFFSET $GAMEGENIE_BYTE`"
	if [[ $? -eq 0 ]]; then
		echo "Game Genie cheat applied!"
	else
		echo -e "Error applying Game Genie cheat:\n$RESULT"
	fi

else
	RESULT="`./gamegenie.sh $GAMEGENIE_OFFSET $ORIGINAL_BYTE`"
	if [[ $? -eq 0 ]]; then
		echo "Game Genie cheat removed"
	else
		echo -e "Error applying Game Genie cheat:\n$RESULT"
	fi

fi

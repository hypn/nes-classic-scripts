#!/bin/bash

# Attempts to find the "NES" header string in a portion of heap (for other things - eg: game genie - to calculate offsets from)

# to speed things up we'll ignore a chunk of the beginning and end of the heap
IGNORE_FROM_START=700000
IGNORE_FROM_END=10000

# same as dump heap:
PID=`pgrep kachikachi`                                            	# kachikachi is the emulator binary
if [[ -z "$PID" ]]; then
  echo "Could not find NES emulator pid."
  exit 1
fi
HEAP=`cat /proc/$PID/smaps | grep heap | awk -F"-" '{print $1}'`  	# find pid's heap address
END=`cat /proc/$PID/smaps | grep heap | awk -F"[- ]" '{print $2}'` 	# find pid's heap address
HEAP_DEC=`printf "%d" 0x$HEAP`                                    	# convert heap address to decimal for busybox's dd
END_DEC=`printf "%d" 0x$END`                                      	# convert heap address to decimal for busybox's dd
COUNT=$(($END_DEC - $HEAP_DEC))

# if we have an offset cache file and we find it is still valid, return it
if [ -e /tmp/rom_offset.txt ]; then

	# DEBUG:
	# echo "Found /tmp/rom_offset.txt cache file"

  OFFSET_DEC="`cat /tmp/rom_offset.txt`"
  SKIP=$(($HEAP_DEC + $OFFSET_DEC))
  CHECK="`dd if=/proc/$PID/mem bs=1 skip=$SKIP count=3 2>/dev/null | xxd | awk '{print $4}'`"


  if [ $CHECK = "NES" ]; then
  	# DEBUG:
		# echo "Offset $OFFSET_DEC (decimal) returned \"NES\""
  	printf "0x%08x" $OFFSET_DEC;
  	exit 0
  fi

	# DEBUG:
	# echo "Offset $OFFSET_DEC (decimal) did not return \"NES\""
fi

# else do all the work :/

# DEBUG:
# echo "No cache file or no longer correct, finding offset..."

HEAP_DEC=$(($HEAP_DEC + $IGNORE_FROM_START))
END_DEC=$(($END_DEC - $IGNORE_FROM_END))
COUNT=$(($END_DEC - $HEAP_DEC))

# write out to file otherwise the NES crashes when "xxd" and "grep"ing :/
OUTPUT="/tmp/find-nes-offset.bin"

dd if=/proc/$PID/mem bs=1 skip=$HEAP_DEC count=$COUNT 2>/dev/null > $OUTPUT
OFFSET="`xxd $OUTPUT | grep NES | awk -F':' '{print $1}'`"
rm $OUTPUT

if [[ -z "$OFFSET" ]]; then
  echo "Could not find \"NES\" header (rom offset) - unsupported mapper?"
  exit 1
fi

# convert hex offset to decimal
OFFSET_DEC=`printf "%d" 0x$OFFSET`
OFFSET_DEC=$(($OFFSET_DEC + $IGNORE_FROM_START)) # convert to full offset from heap

# cache the offset to file
echo $OFFSET_DEC > /tmp/rom_offset.txt

# return it
printf "0x%08x" $OFFSET_DEC;

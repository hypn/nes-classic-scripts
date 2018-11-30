#!/bin/bash

# Writes a byte to a given address

if [[ "$#" -ne 2 ]]; then
  echo "Usage:"
  echo "  $0 <offset in hex> <byte>"
  echo
  exit 1
fi

PID=`pgrep kachikachi`                                            # kachikachi is the emulator binary
if [ $PID ]
then
	HEAP=`cat /proc/$PID/smaps | grep heap | awk -F"-" '{print $1}'`  # find pid's heap address
	if [ $HEAP ]
	then
		BASE=`printf "%d" 0x$HEAP`                                        # convert heap address to decimal for busybox's dd
		OFFSET=`printf "%d" $1`                                           # convert offset to decimal for busybox's dd
		ADDRESS=$(($BASE + $OFFSET))                                      # final address to write to
		BYTE=`echo -ne "\x${2/0x/}"`                                      # binary byte to write

		# DEBUG:
		# echo "Writing to: `printf "0x%x" $ADDRESS` (0x$HEAP + $1)"

		echo -n $BYTE | dd of=/proc/$PID/mem bs=1 seek=$ADDRESS conv=notrunc count=1 2>/dev/null
	else
		exit 1
	fi
else
	exit 1
fi

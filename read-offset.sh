#!/bin/bash

# Reads a byte from a given address

if [[ "$#" -ne 1 ]]; then
  echo "Usage:"
  echo "  $0 <offset in hex>"
  echo
  exit 1
fi

PID=`pgrep kachikachi`                                            	# kachikachi is the emulator (binary)
if [ $PID ]
then
	HEAP=`cat /proc/$PID/smaps | grep heap | awk -F"-" '{print $1}'`  # find kachikachi's heap address
	if [ $HEAP ]
	then
		BASE=`printf "%d" 0x$HEAP`                                        # convert heap address to decimal (for busybox's dd)
		OFFSET=`printf "%d" $1`                                           # convert offset to decimal (for busybox's dd)
		ADDRESS=$(($BASE + $OFFSET))                                      # final address to read from

		# DEBUG:
		# echo "Reading from: `printf "0x%x" $ADDRESS` ($ADDRESS) = $1 + 0x$HEAP"

		dd if=/proc/$PID/mem bs=1 skip=$ADDRESS count=1 2>/dev/null | xxd -p | awk '{print $1}'
	else
		exit 1
	fi
else
	exit 1
fi

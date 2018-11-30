#!/bin/bash

# Dumps the full memory heap to disk

PID=`pgrep kachikachi`                                            	# kachikachi is the emulator binary
HEAP=`cat /proc/$PID/smaps | grep heap | awk -F"-" '{print $1}'`  	# find pid's heap address
END=`cat /proc/$PID/smaps | grep heap | awk -F"[- ]" '{print $2}'` 	# find pid's heap address
HEAP_DEC=`printf "%d" 0x$HEAP`                                    	# convert heap address to decimal for busybox's dd
END_DEC=`printf "%d" 0x$END`                                      	# convert heap address to decimal for busybox's dd
COUNT=$(($END_DEC - $HEAP_DEC))

if [[ "$#" -ne 1 ]]; then
	OUTPUT="/tmp/heap.bin"
else
	OUTPUT=$1
fi

dd if=/proc/$PID/mem bs=1 skip=$HEAP_DEC count=$COUNT 2>/dev/null > $OUTPUT
echo "Dumped heap to: $OUTPUT (`stat -c "%s" $OUTPUT`)"

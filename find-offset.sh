#!/bin/bash

# scans decimal numbered .bin files for their hex value in memory (eg: 10.bin -> 0a in memory), and returns the most occurring memory address(es)

ls *.bin | awk -F. '{print $1}' | while read file; do
	DEC=`echo $file | sed 's/^0*//'` # 08 and 09 are treated as hex but aren't valid so results in an error
	HEX=`printf "%02x" $DEC`;
	xxd -c1 $file.bin | grep " $HEX" | awk '{print $1}';
done | sort | uniq -c | sort | tail -n 20

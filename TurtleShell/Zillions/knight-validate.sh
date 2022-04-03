#!/bin/sh

# Validate knight-connections.txt

# Make sure:
# 1) All paths are only seen once
# 2) All paths have a return path

fgrep -v '#' knight-connections.txt | tr -d '\015' | grep '(' | awk -F'(' '
{for(a=2;a<=9;a++){
if($a){path=$a;gsub(/)/,"",path);gsub(/ /,"",path); 
inverse = substr(path,3,2) substr(path,1,2)
if(seen[path]){print "FATAL: Connection " path " already seen"} 
seen[path]=inverse;}}}
END {
	for(path in seen) {inverse=seen[path];
	                   if(!seen[inverse])
		{print "FATAL: Connection " inverse " not seen" }
	}}'

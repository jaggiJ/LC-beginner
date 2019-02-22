#!/bin/bash

# PASSWORDS CREATION SCRIPT.


set -x  # DEBUG TOGGLE

#1 To create 15 characters long passwords containing A-Z a-z 0-9 I choose to use random
#  data generated in /dev/urandom as fast and sufficient for the task. I remove all
#  characters from it except desired using `tr -dc`. I use `fold -w 15` to keep generated
#  output to 15 characters long per line.
#2 Now I can decide size of a file that will contain my passwords. 15 character long line

# INSTANTLY CREATE FILE WITH RANDOM PASSWORDS OF 1MiB SIZE
# one mebibyte(1MiB)  = 1048576 bytes
# each 15 char password line adds 16 bytes, so 1048576/16=65536 lines for 1MiB file

cat /dev/urandom |tr -dc 'A-Za-z0-9'|fold -w 15|head -n 65536 >>passes

# ALTERNATIVE WAY: ADDING PASSWORDS THROUGH ITERATIONS UNTIL FILE SIZE REACH VALUE
# STORED IN $passes_max_size using: wc, stat, ls or du commands.

#passes_size=0
# Set amount of bytes to control size of `passes` file.
#passes_max_size=1000
#while [[ "$passes_size" -lt "$passes_max_size" ]]
#do
    #cat /dev/urandom |tr -dc 'A-Za-z0-9'|fold -w 15|head -n 1 >>passes
    #passes_size=$(wc -c passes|cut -d " " -f 1)
    #passes_size=$(stat -c %s passes)
    #passes_size=$(ls -l passes|cut -d " " -f 5)
    #passes_size=$(du -b passes|cut -f 1)
    #echo "$passes_size"/"$passes_max_size"
#done

set +x  # DEBUG TOGGLE




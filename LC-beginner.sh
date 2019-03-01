#!/bin/bash

# PASSWORDS CREATION SCRIPT.

#1 HOW LINES OF PASSWORDS ARE CREATED ?

# To create 15 characters long passwords per line, containing 'A-Z a-z 0-9' I
# choose to use random data from /dev/random. Its good for cryptography
# purposes, while faster /dev/urandom is more suitable for testing or filling
# space with random data. All characters except desired are removed using `tr
# -dc`. I use `fold -w 15` to keep generated output to 15 characters long per
# line. LC_ALL solves some possible problems with `tr` complaining about input.
# Using regular expressions grep assures quality of password that must contain
# all of instances: upper, lower case and digit.

#2 HOW FILE SIZE IS KEPT UNDER CONTROL ?

# Good way to control size of a file is to create it with command restraining
# it to specific number of lines, or set up loop that checks for file size and
# breaks when its reached or extended. Using 'head -n 65536' would create file
# of exactly 1MiB in one go. Also 'dd bs=1048576 count=1 status=none'. One
# mebibyte(1MiB) = 1048576 bytes. Each 15 char password line adds 16 bytes.
# Script is written in a way it terminates after created file reaches certain
# size. Passwords in batches of 256 lines (4096 bytes) 'head -n 256 >> passwd1'
# are added to a file, until the size is 1048576 bytes (1MiB). To find
# file-size loop with: 'wc -c passwd1|cut -d" " -f1' is used to store current
# file size in a variable 'size'. Each iteration this is compared with set
# size-limit in condition: '[[ size -lt 1048576 ]]'. Loop stops when the
# condition is met and results with file of desired size. Another method to
# check file size is used later to echo final size to user: 'du -h passwd1'.
# This one comes with convenient output format for human eyes.

# Backup old files if present.

[[ -f passwd1 ]] && mv passwd1 backup-passwd1 \
    && echo Made backup of old '"passwd1"' into '"backup-passwd1"' \
    && echo Press a key && read -r

[[ -f passwd2 ]] && mv passwd2 backup-passwd2 \
    && echo Made backup of old '"passwd2"' into '"backup-passwd2"' \
    && echo Press a key && read -r

# Main part of script, password file creation with size control.

size=0
while [[ size -lt 1048576 ]] ; do
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/random |fold -w 15|grep "[[:upper:]]"\
        |grep "[[:lower:]]"|grep "[[:digit:]]"|head -n 256 >> passwd1
    size=$(wc -c passwd1|cut -d" " -f1)
    echo "$size"/1048576 bytes created
done
    # Output if all went good or not.
if [[ $(ywc -c passwd1|cut -d" " -f1) -eq 1048576 ]] ; then
    echo Successfully created file of size: "$(du -h passwd1)"
else
    echo Something went not as expected. Check if created file size is equal \
         to 1048576 bytes.
fi

#3 SORTING PASSWORD FILE

# Most common command to sort file in Linux is "sort" The locale specified by
# the environment affects sort order. Set LC_ALL=C to get the traditional sort
# order that uses native byte values.: default sorting order: 0-9A-Z-a-z
# (US-ASCII) I use random sorting style with -u to remove duplicate passwords.
# Sort with '-o' let me save result into file with same filename. Random sorting
# style enables grouping of identical entries so its possible to remove
# duplicates with -u option, plus its handy when I need not similar passwords
# when picked up line by line from beginning of file.

size=$(wc -l passwd1|cut -d" " -f1)
LC_ALL=C sort -Ruo passwd1 passwd1
size2=$(wc -l passwd1|cut -d" " -f1)
echo Passwords sorted with random order.
[[ ! $size2 -eq $size ]] \
    && echo Number of duplicates found and removed: "$(( size-size2 ))"

#4 REMOVING LINES STARTING WITH 'A'or 'a' USING REGULAR EXPRESSIONS
#  Result saved into new file 'passwords'.
#  'grep -v' prints all except lines provided with patterns preceded by '-e'.
#  Output redirected into 'passwords' file.

grep -v -e "^A" -e "^a" passwd1 > passwd2
echo Removing passwords starting with '"A"' or '"a"'.
echo ... && sleep 1 && echo Result saved in '"passwd2"' file.

#5 HOW MANY LINES WERE REMOVED ?
#  Using cut with delimiter set for whitespace let me output numeric value
#  alone. Operation done on output of 'wc -l ' command generates number of
#  lines in a file. I seek here for difference between number of lines between
#  two of my password files. This is the number of removed passwords in
#  previous step. I store it in a variable 'lines_difference'.

size_final=$(wc -l passwd2|cut -d" " -f1)
lines_difference=$(( size2-size_final ))
echo Total of "$lines_difference" passwords were removed out of "$size2"

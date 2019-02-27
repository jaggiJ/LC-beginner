#!/bin/bash

# PASSWORDS CREATION SCRIPT.

#1 INSTANTLY CREATE FILE WITH RANDOM PASSWORDS OF 1MiB SIZE To create 15
#  characters long passwords containing A-Z a-z 0-9 I choose to use random data
#  generated in /dev/urandom as fast and sufficient for the task. I remove all
#  characters from it except desired using `tr -dc`. I use `fold -w 15` to keep
#  generated output to 15 characters long per line. LC_ALL solves some possible
#  problems with `tr` complaining about input. Train of pipe with grep assures
#  quality of password that must contain all of instances: upper, lower case and
#  digit.

#2 One mebibyte(1MiB) = 1048576 bytes.
#  Each 15 char password line adds 16 bytes, so 1048576/16=65536 lines for
#  total size of 1MiB.

# To write a script in a way it terminates after reaching certain size i decide
# to append passwords in blocks of 256 (4096 bytes)until they reach size of
# 1048576 bytes (1MiB) `head -n 256 >> passes`

# Backup old files if present.
[[ -f passes ]] && mv passes backup-passes && echo Made backup of old \
                \"passes\" into \"backup-passes\" && echo Press a key && read

[[ -f passwords ]] && mv passwords backup-passwords && echo Made backup of old \
                      \"passwords\" && echo Press a key && read

# Main part of script, password file creation with size control.

size=0
while [[ size -lt 1048576 ]]
do
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom |fold -w 15|grep [[:upper:]]\
        |grep [[:lower:]]|grep [[:digit:]]|head -n 256 >> passes
    size=$(wc -c passes|cut -d" " -f1)
    echo "$size"/1048576 bytes created
done

if [[ $(wc -c passes|cut -d" " -f1) -eq 1048576 ]] ; then
    echo Successfully created file of size: $(du -h passes)
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

size=$(wc -l passes|cut -d" " -f1)
LC_ALL=C sort -Ruo passes passes
size2=$(wc -l passes|cut -d" " -f1)
echo Passwords sorted with random order.
[[ ! $size2 -eq $size ]] && echo Number of duplicates found and removed: \
                                 $(( "$size"-"$size2" ))

#4 REMOVING LINES STARTING WITH "A"or "a" and saving the result into new file
#  'passwords'.
#  'grep -v' prints all except lines provided with patterns preceded by '-e'.
#  Output redirected into 'passwords' file.
#grep -v -e "^A" -e "a" passes > passwords
    #echo Passwords starting with \'A\' or \'a\' are removed. Result saved in \
        #\'passwords\' file.
#
#5 HOW MANY LINES WERE REMOVED ? Using cut with delimiter set for whitespace let
#  me output numeric value alone. Operation done on output of 'wc -l ' command
#  generates number of lines in a file. I seek here for difference between
#  number of lines between two of my password files. This is the number of
#  removed passwords in previous step. I store it in a variable
#  'lines_difference'.
#lines_difference=$(( $(wc -l passes|cut -d" " -f1)\
#                         -$(wc -l passwords|cut -d" " -f1) ))
#echo Total of "$lines_difference" passwords were removed.


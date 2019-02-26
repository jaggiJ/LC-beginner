#!/bin/bash

# PASSWORDS CREATION SCRIPT.

#1 INSTANTLY CREATE FILE WITH RANDOM PASSWORDS OF 1MiB SIZE To create 15
#  characters long passwords containing A-Z a-z 0-9 I choose to use random data
#  generated in /dev/urandom as fast and sufficient for the task. I remove all
#  characters from it except desired using `tr -dc`. I use `fold -w 15` to keep
#  generated output to 15 characters long per line. 
#2 One mebibyte(1MiB) = 1048576 bytes.
#  Each 15 char password line adds 16 bytes, so 1048576/16=65536 lines for
#  total size of 1MiB.

< /dev/urandom tr -dc 'A-Za-z0-9'|fold -w 15|head -n 65536 >passes
pass_quantity=
echo Created \'passes\' file containing "$(wc -l passes|cut -d" " -f1)"\
      passwords.

#passes_size=0
# Set amount of bytes to control size of "passes" file.
#passes_max_size=1000
#while [[ "$passes_size" -lt "$passes_max_size" ]]
#do
#    < /dev/urandom tr -dc 'A-Za-z0-9'|fold -w 15|head -n 1 >>passes
#    passes_size=$(wc -c passes|cut -d " " -f 1)
#    passes_size=$(stat -c %s passes)
#    passes_size=$(ls -l passes|cut -d " " -f 5)
#    passes_size=$(du -b passes|cut -f 1)
#    echo "$passes_size"/"$passes_max_size"
#done

#3 SORTING PASSWORD FILE
# Most common command to sort file in Linux is "sort"
# The  locale specified by the environment affects sort
# order.  Set LC_ALL=C to get the traditional sort order that uses  native
# byte values.: default sorting order: 0-9A-Z-a-z (US-ASCII)
# I go with default sorting with -u to remove duplicates. Sort with '-o' let me
# save result in place (as same file).

LC_ALL=C sort -uo passes passes
echo File \'passes\' sorted with default US-ASCII order.

# Remove passwords not containing all of the characters: upper, lower, digit.
grep '[[:upper:]]' passes|grep '[[:lower:]]'|grep '[[:digit:]]' > passes_tmp
pass_rem=$(( $(wc -l passes|cut -d" " -f1)-$(wc -l passes_tmp|cut -d" " -f1) ))
echo Detected and removed "$pass_rem" weak passwords.
mv passes_tmp passes

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


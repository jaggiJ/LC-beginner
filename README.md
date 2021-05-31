# LC-beginner PASSWORDS CREATION SCRIPT.
60k+ random passwords.  
All passwords contains 15 characters from range: A-Z a-z 0-9
All passwords are containing at least upper, lower case and digit characters.  
Passwords are created in batches of 256 until file size reaches set limit 1MiB.

```
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
# it to specific number of lines or bytes. Also loop that checks for file size
# and breaks when its reached or extended can be used. One mebibyte(1MiB) =
# 1048576 bytes. Each 15 char password line adds 16 bytes. Option 'head -n
# 65536' would create file of exactly 1MiB in one go. Also 'dd bs=1048576
# count=1 status=none'. for demonstration purposes the script is written in a
# way it terminates after created file reaches certain size. Passwords in
# batches of 256 lines (4096 bytes) 'head -n 256 >> passwd1' are added to a
# file, until the size is 1048576 bytes (1MiB). To find file-size loop with:
# 'wc -c passwd1|cut -d" " -f1' is used to store current file size in a
# variable 'size'. Each iteration this is compared with set size-limit in
# condition: '[[ size -lt 1048576 ]]'. Loop stops when the condition is met and
# results with file of desired size. Another method to check file size is used
# later to echo final size to user: 'du -h passwd1'. This one comes with
# convenient output format for human eyes. Different commands to check file
# size are: 'ls -l' and 'stats -c %s'

#3 SORTING PASSWORD FILE

# Most common command to sort file in Linux is "sort" The locale specified by
# the environment affects sort order. Set LC_ALL=C to get the traditional sort
# order that uses native byte values.: default sorting order: 0-9A-Z-a-z
# (US-ASCII) I use random sorting style '-R' with '-u' to remove duplicate passwords.
# Sort with '-o' let me save result into file with same filename.

#4 REMOVING LINES STARTING WITH 'A'or 'a' USING REGULAR EXPRESSIONS

#  'grep -v' prints all except lines provided with patterns preceded by '-e'.
#  Result saved into new file 'passwd2'.

#5 HOW MANY LINES WERE REMOVED ?

# I look for difference between number of lines of my password files. This is
# the number of removed passwords in previous step. I store it in a variable
# 'lines_difference'.
```
![example_pass](https://user-images.githubusercontent.com/18056024/120233934-2db96480-c257-11eb-8aaf-7cc87ddc9aac.jpg)

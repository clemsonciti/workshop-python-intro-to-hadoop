#!/software/spackages/linux-centos8-x86_64/gcc-8.3.1/anaconda3-2019.10-v5cuhr6keyz5ryxcwvv2jkzfj2gwrj4a/bin/python
import sys

current_word = None
total_word_count = 0

for line in sys.stdin:
    line = line.strip()
    word, count = line.split("\t", 1)
    try:
        count = int(count)
    except ValueError:
        continue
    
    if current_word == word:
        total_word_count += count
    else:
        if current_word:
            print ("%s\t%s" % (current_word, total_word_count))
        current_word = word
        total_word_count = 1
        
if current_word == word:
    print ("%s\t%s" % (current_word, total_word_count))
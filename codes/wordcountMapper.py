#!/software/spackages/linux-centos8-x86_64/gcc-8.3.1/anaconda3-2019.10-v5cuhr6keyz5ryxcwvv2jkzfj2gwrj4a/bin/python             
import sys                                                                                                
for oneLine in sys.stdin:
    oneLine = oneLine.strip()
    for word in oneLine.split(" "):
        if word != "":
            print ('%s\t%s' % (word, 1)) 
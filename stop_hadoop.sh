#!/bin/bash

echo "Shutting down Hadoop cluster at " $(hostname)

# this is to handle the current issue with Anaconda's builtin ssl
export LD_PRELOAD=/usr/lib64/libcrypto.so.1.1:$LD_PRELOAD

./bin/namenode_shutdown.sh $(hostname)





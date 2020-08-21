#!/bin/bash

echo "Namenode hostname" $(hostname)

# this is to handle the current issue with Anaconda's builtin ssl
export LD_PRELOAD=/usr/lib64/libcrypto.so.1.1:$LD_PRELOAD

pbsdsh sleep 5
echo "Check temp dir creations"

cat $PBS_NODEFILE | sort | uniq > nodes.txt
while read line
do
  echo $line
  cmd="hostname; touch ${TMPDIR}/test; ls -l ${TMPDIR}"
  ssh -tt $line $cmd < /dev/null
done < nodes.txt

./bin/namenode.sh $(hostname)





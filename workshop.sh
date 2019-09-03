#!/bin/bash

i=200
while [ $i -le "230" ]
do 
echo "workshop workshop workshop_$i@datarobot.com" >> workshop.txt
i=$((i+1))
done
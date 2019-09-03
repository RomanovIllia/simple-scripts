#!/bin/bash
down=101000001841
up=101150001625
echo "$down">random.txt
i=1
while [ $i -le "2098" ]
do
result=$(python -S -c "import random; print random.randrange(1,500000)")
down=$(($down+$result))
echo "$down" >> random.txt
i=$(($i+1))
done
echo "$up" >> random.txt
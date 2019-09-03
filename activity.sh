#!/bin/bash

while read line 
do
userid=$(echo "$line" | cut -d ' ' -f 2)
email=$(echo "$line" | cut -d ' ' -f 1)
head -n 1 ~/Downloads/activity/5.2.0-2019-06-03_app_data.csv >> $email.csv
grep -i $userid ~/Downloads/activity/5.2.0-2019-06-03_app_data.csv >> $email.csv
done < userlist
#!/bin/bash

echo "Please specify the service/PID or leave empty for all services"
read service
echo -e "Please specify start timestamp in YYYY-MM-DD-hh-mm-ss format or leave empty to check all file"
read vardate
startdate=$(date -jf "%Y-%m-%d-%H-%M-%S" $vardate "+%s")
rm errorlog.log 2> /dev/null
if [ -z "$service" ]
then 
	grep -i error all.log | cut -d ' ' -f 1 | cut -d '.' -f 1 | tr 'T' '-' > time.txt
	grep -i error all.log | rev | cut -d '@' -f 1 | rev > message.log
		if [ -z "$vardate" ]
		then
			paste time.txt message.log > errorlog.log
		else
			paste time.txt message.log > temperrorlog.log
				
				while read line
				do
					line1=$(echo "$line" | cut -d 'm' -f 1 )
					errordate=$(date -jf '%Y-%m-%d-%H:%M:%S' $line1 "+%s")
						if [[ "$errordate" > "$startdate" ]]
						then 
							echo "$line" >> errorlog.log
						else
							echo "$errordate" > /dev/null
						fi
				done < temperrorlog.log		
		fi	
else
	grep -i $service all.log > servicefile.txt
	grep -i error servicefile.txt | cut -d ' ' -f 1 | cut -d '.' -f 1 | tr 'T' '-' > time.txt
	grep -i error servicefile.txt | rev | cut -d '@' -f 1 | rev > message.log
		if [ -z "$vardate"]
		then
			paste time.txt message.log > errorlog.log
		else 
			paste time.txt message.log > temperrorlog.log
				while read line
				do
					line1=$(echo "$line" | cut -d 'm' -f 1 )
					errordate=$(date -jf '%Y-%m-%d-%H:%M:%S' $line1 "+%s")
						if [[ "$errordate" > "$startdate" ]]
						then 
							echo "$line" >> errorlog.log
						else
							echo "$errordate" > /dev/null
						fi
				done < temperrorlog.log
		fi
fi
echo -e "\nPlease check errorlog.log file\n"
rm newtime.txt 2> /dev/null
rm time.txt  2> /dev/null
rm dateonly.txt 2> /dev/null
rm temperrorlog.log 2> /dev/null
rm message.log 2> /dev/null

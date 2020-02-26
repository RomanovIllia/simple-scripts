#!/bin/bash

TOKEN='' #Place your Jenkins token here
USER='' #Place your Jenkins user ID

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

if [ "$1" == '--help' ] || [ "$1" == '-h' ]
then
	echo ""
	echo -e "This script can be used for generating DataRobot tarballs and license"
	echo -e "Please insert your Jenkins credentials in the body of script before running it"
	echo ""
	echo -e "${GREEN}Options available : "
	echo ""
	echo -e "${YELLOW}--no-hadoop${NC} - links only for for dockerized install and DataRobot license"
	echo ""
else

echo -en "${GREEN}Insert version : ${NC}"
read version
echo -en "${GREEN}Insert workers count : ${NC}"
read workers
echo -en "${GREEN}License good for days : ${NC}"
read days
cd 
source ~/aws_access_local

before=$(curl --silent -X GET https://jenkins.xxxxxxx.com/job/xxxx/xxxxx/json?pretty=true\
  --user $USER:$TOKEN) 

curl --silent -X POST https://$USER@jenkins.xxxxxx.com/xxx/xxxx/xx \
--user $USER:$TOKEN \
--data 'name=licensing_sha1&value=origin%2Fmaster&name=license_good_for_days&value='$days'&name=concurrent_workers&value='$workers'&name=jarvis_id&value=&name=jarvis_endpoint&value=https%3A%2F%2Fjarvis-proxy.drdev.io%2Fincoming%2Fjenkins%2F&name=JARVIS_ENV&value=&name=jarvis_node&label=remote-automation&statusCode=303&redirectTo=.&json=%7B%22parameter%22%3A+%5B%7B%22name%22%3A+%22licensing_sha1%22%2C+%22value%22%3A+%22origin%2Fmaster%22%7D%2C+%7B%22name%22%3A+%22license_good_for_days%22%2C+%22value%22%3A+%22'$days'%22%7D%2C+%7B%22name%22%3A+%22concurrent_workers%22%2C+%22value%22%3A+%22'$workers'%22%7D%2C+%7B%22name%22%3A+%22jarvis_id%22%2C+%22value%22%3A+%22%22%7D%2C+%7B%22name%22%3A+%22jarvis_endpoint%22%2C+%22value%22%3A+%22https%3A%2F%2Fjarvis-proxy.drdev.io%2Fincoming%2Fjenkins%2F%22%7D%2C+%7B%22name%22%3A+%22JARVIS_ENV%22%2C+%22value%22%3A+%22%22%7D%2C+%7B%22name%22%3A+%22jarvis_node%22%2C+%22label%22%3A+%22remote-automation%22%7D%5D%2C+%22statusCode%22%3A+%22303%22%2C+%22redirectTo%22%3A+%22.%22%7D'

after=$(curl --silent -X GET https://jenkins.xxxxxxx.com/xxxx/xxxx/xxx/json?pretty=true\
  --user $USER:$TOKEN) 

build_id=$(diff  <(echo -e "$after" ) <(echo -e "$before") | grep -i '"number"' | head -n 1 | cut -d ':' -f 2 | cut -d ',' -f 1 | sed 's/ //g')

printf 'Processing: '
tput civis
while : ; do 
curl --fail --silent -X GET https://jenkins.xxxxxx.com/xxx/xxxx/$build_id/artifact/xxxxxx/jenkins/license.json.SHA256withRSA.txt\
 --user $USER:$TOKEN > /dev/null && printf 'done' && break;
 for a in / - \* \\ \|; do
    printf '%s\b' "$a" 
    sleep 1
  done; sleep 1
 done 
echo " "
tput cnorm

license=$(curl --silent -X GET https://jenkins.xxxxxxx.com/xxxxxx/xxxxxx/xxx/$build_id/artifact/xxxxxxx/jenkins/license.json.SHA256withRSA.txt \
  --user $USER:$TOKEN) 

echo -e "${YELLOW}-------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e ""
echo -e "${GREEN}Links for ${YELLOW}DataRobot${GREEN} v${version}, valid for${YELLOW} 7${GREEN} days."
echo -e ""
echo -e "${GREEN}-- ${YELLOW}Tarball${GREEN} URL --${NC}"
OUTPUT=$(./sign_s3_url.bash --region us-east-1 --bucket datarobot-enterprise-releases --minute-expire 10080 --file-path "promoted/${version}/dockerized/DataRobot-RELEASE-${version}.tar.gz")

echo -e "${OUTPUT}"
echo -e ""
echo -e "${GREEN}Example tarball download command:${NC}"
echo -e "curl -o DataRobot-RELEASE-${version}.tar.gz \"${OUTPUT}\""

echo -e ""

echo -e "${GREEN}-- ${YELLOW}Shafile${GREEN} URL --${NC}"
OUTPUT=$(./sign_s3_url.bash --region us-east-1 --bucket datarobot-enterprise-releases --minute-expire 10080 --file-path "promoted/${version}/dockerized/DataRobot-RELEASE-${version}.tar.gz.sha1sum")
echo -e "${OUTPUT}"
echo -e ""
echo -e "${GREEN}Example shafile download command:${NC}"
echo -e "curl -o DataRobot-RELEASE-${version}.tar.gz.sha1sum \"${OUTPUT}\""
echo -e ""

	if [ "$1" == '--no-hadoop' ]
	then
		echo -e "${YELLOW}-------------------------------------------------------------------------------------------------------------------------------------------------------"
		echo -e " "
		echo -e "${GREEN}-- ${YELLOW}License${GREEN} Information --"
		echo -e " "
		echo -e "${GREEN}Expiration date : ${NC}" $(date -v +"$days"d) 
		echo -e "${GREEN}Workers count : ${NC}" $workers
		echo -e "${GREEN}Build ID : ${NC}"$build_id 
		echo -e " "
		echo -e "${GREEN}License : ${NC}"
		echo -e $license

		exit 0
	else
		echo -e "${YELLOW}-------------------------------------------------------------------------------------------------------------------------------------------------------"
		echo -e "${GREEN}Links for DataRobot v${version} ${YELLOW}Hadoop${GREEN} Integration, valid for${YELLOW} 7${GREEN} days."
		echo -e ""
		echo -e "${GREEN}--${YELLOW} Tarball${GREEN} URL --${NC}"
		OUTPUT=$(./sign_s3_url.bash --region us-east-1 --bucket datarobot-enterprise-releases --minute-expire 10080 --file-path "promoted/${version}/hadoop/DataRobot-RELEASE-hadoop-${version}.tar")

		echo -e "${OUTPUT}"
		echo -e ""
		echo -e "${GREEN}Example tarball download command:${NC}"
		echo -e "curl -o DataRobot-RELEASE-hadoop-${version}.tar \"${OUTPUT}\""

		echo -e ""

		echo -e "${GREEN}--${YELLOW} Shafile${GREEN} URL --${NC}"
		OUTPUT=$(./sign_s3_url.bash --region us-east-1 --bucket datarobot-enterprise-releases --minute-expire 10080 --file-path "promoted/${version}/hadoop/DataRobot-RELEASE-hadoop-${version}.tar.sha1sum")

		echo -e "${OUTPUT}"
		echo -e ""
		echo -e "${GREEN}Example shafile download command:${NC}"
		echo -e "curl -o DataRobot-RELEASE-hadoop-${version}.tar.sha1sum \"${OUTPUT}\""
		echo -e ""
		echo -e "${YELLOW}-------------------------------------------------------------------------------------------------------------------------------------------------------"
		echo -e " "
		echo -e "${GREEN}-- ${YELLOW}License${GREEN} Information --"
		echo -e " "
		echo -e "${GREEN}Expiration date : ${NC}" $(date -v +"$days"d) 
		echo -e "${GREEN}Workers count : ${NC}" $workers
		echo -e "${GREEN}Build ID : ${NC}"$build_id 
		echo -e " "
		echo -e "${GREEN}License : ${NC}"
		echo -e $license

	fi

fi

#!/bin/bash

echo "Enter Capture domain to .janraincapture.com"
    read domain
echo "Enter App Owner ID"
    read clientid
echo "Enter App Owner Secret"
    read secret

auth=$(echo $clientid:$secret|base64 --wrap=0) #base64 encoding of ID and Secret
corr_auth=$(echo ${auth%?}=)

    curl -H "Authorization: Basic $corr_auth"\
        https://$domain.janraincapture.com/settings/keys > list.txt  # get list of global settings

string=$(cat list.txt )
rm list.txt
symb_rm=$(echo $string | sed -e 's,result,,g'|sed 's/, */, /g'| sed '/[[:punct:]]*/{ s/[^[:alnum:][:space:]_%-]//g}' | sed -e 's,statok,,g')   
 #deleting extra symbols
echo "########## Global settings for $domain.janraincapture.com ##########" > customer_settings.txt
for key in $symb_rm
    do
        echo -e '\n' $key >> customer_settings.txt
        settings_line=$(curl -H "Authorization: Basic $corr_auth"\
            --data-urlencode key=$key \
            https://$domain.janraincapture.com/settings/get)
        echo ${settings_line:10:-13}  >> customer_settings.txt
    done  #get grobal settings

clients_list=$(curl -H "Authorization: Basic $corr_auth"\
    https://$domain.janraincapture.com/clients/list)     #get clients list

client_ids_list=$(echo $clients_list | sed 's/, */, /g'| sed '/[[:punct:]]*/{ s/[^[:alnum:][:space:]_:%-]//g}' | tr " " "\n" | grep client_id | sed -e 's,client_id:,,g' ) 
# searching for client ID's

for id in $client_ids_list
    do
        echo -e '\n'"########## Client ID = $id ##########"'\n' >> customer_settings.txt
        settings_scope=$(curl -H "Authorization: Basic $corr_auth"\
            --data-urlencode for_client_id=$id \
            https://$domain.janraincapture.com/settings/items)
        echo ${settings_scope:12:-14}  >> customer_settings.txt
    done
# getting settings for each customer
clear
cat customer_settings.txt
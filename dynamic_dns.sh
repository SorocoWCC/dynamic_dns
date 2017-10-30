#!/bin/bash

# Your Domain name ie: www.tect.com
DOMAIN_NAME="gilisywate.com"
# Current IP mapped on DNS
DNS_IP=$(dig +short $DOMAIN_NAME)
# Local IP
LOCAL_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Compares both IPs to validate if DNS must be updated.
if [ "$DNS_IP" != "$LOCAL_IP" ]
	then
	echo "DNS UPDATE"
	# Creates the json file to create the recorset
	echo "{" >> recordset.json
	echo "    \"Comment\": \"Recorset\"," >> recordset.json
	echo "    \"Changes\": [" >> recordset.json
	echo "        {" >>recordset.json
	echo "            \"Action\": \"UPDATE\",">> recordset.json
	echo "            \"ResourceRecordSet\": {">> recordset.json
	echo "                \"Name\": \"$DOMAIN_NAME\"," >> recordset.json
	echo "                \"Type\": \"A\"," >> recordset.json
	echo "                \"TTL\": 60," >> recordset.json
	echo "                \"ResourceRecords\": [" >> recordset.json
	echo "                    {" >> recordset.json
	echo "                        \"Value\": \"$LOCAL_IP\"" >> recordset.json
	echo "                    }" >> recordset.json
	echo "                ]" >> recordset.json
	echo "            }" >> recordset.json
	echo "        }">> recordset.json
	echo "    ]" >> recordset.json
	echo "}" >>recordset.json

	/usr/local/bin/aws route53 change-resource-record-sets --hosted-zone-id Z3QZDGDOU3F9WW --change-batch file://recordset.json
	rm recordset.json
fi
#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

echo "POST request Enroll on Nxia  ..."
echo
Nxia_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=nxia&password=password&orgName=nxia')
echo $Nxia_TOKEN
Nxia_TOKEN=$(echo $Nxia_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $Nxia_TOKEN"
echo
echo "POST request Enroll on Creator ..."
echo
Nmen_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=nmen&password=password&orgName=nmen')
echo $Nmen_TOKEN
Nmen_TOKEN=$(echo $Nmen_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Creator token is $Nmen_TOKEN"
echo

echo
echo "POST request Create channel  ..."
echo
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"jiakechannel",
	"channelConfigPath":"/tmp/certification/f18fafe1e2b4494696e1dac580ab6c53/channel.tx"
}'
echo
echo

sleep 5


echo "POST request Join channel on Nxia"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/peers \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo

echo "POST request Join channel on Nmen"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/peers \
  -H "authorization: Bearer $Nmen_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
  }'
echo
echo



echo "POST Install chaincode on Jiake"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"jiakechaincode",
	"chaincodePath":"jiakechaincode",
	"chaincodeVersion":"v1.0"
}'
echo
echo


echo "POST Install chaincode on Nmen"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Nmen_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"jiakechaincode",
	"chaincodePath":"jiakechaincode",
	"chaincodeVersion":"v1.0"
}'
echo
echo

echo "POST instantiate chaincode on peer1 of Nxia"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/chaincodes \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"jiakechaincode",
	"chaincodeVersion":"v1.0",
	"args":[]
}'
echo
echo

# echo "POST invoke chaincode on peers of Jiake and Creator"
# echo
# TRX_ID=$(curl -s -X POST \
#   http://localhost:4000/channels/jiakechannel/chaincodes/hlccc \
#   -H "authorization: Bearer $Nxia_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
# 	"fcn":"Register",
# 	"args":[\"[{\"productId\":\"jjjj123\",\"inModule\":\"XXXX10\",\"kind\":\"sheep\",\"type\":\"red_sheep\",\"mapPosition\":\"Northen17°Easten18°\",\"iName\":\"Williams\",\"lairageTime\":\"2001-01-01\",\"days\":\"50\",\"condition\":\"Qualified\",\"comment\":\"Lairage\",\"penNum\":\"A100\"}]\"]
# }')
# echo "Transacton ID is $TRX_ID"
# echo
# echo

echo "GET query chaincode on peer1 of Jiake"
echo
curl -s -X GET \
  "http://localhost:4000/channels/jiakechannel/chaincodes/jiakechaincode?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Block by blockNumber"
echo
curl -s -X GET \
  "http://localhost:4000/channels/jiakechannel/blocks/1?peer=peer1" \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json"
echo
echo

# echo "GET query Transaction by TransactionID on peero in Jiake"
# echo
# curl -s -X GET http://localhost:4000/channels/jiakechannel/transactions/$TRX_ID?peer=peer1 \
#   -H "authorization: Bearer $Nxia_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo


# echo "GET query Transaction by TransactionID on peer1 in Jiake"
# echo
# curl -s -X GET http://localhost:4000/channels/jiakechannel/transactions/$TRX_ID?peer=peer1 \
#   -H "authorization: Bearer $Nxia_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

############################################################################
### TODO: What to pass to fetch the Block information
############################################################################
#echo "GET query Block by Hash"
#echo
#hash=????
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel/blocks?hash=$hash&peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "cache-control: no-cache" \
#  -H "content-type: application/json" \
#  -H "x-access-token: $ORG1_TOKEN"
#echo
#echo

echo "GET query ChainInfo on Jiake peer1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/jiakechannel?peer=peer1" \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=installed" \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Instantiated chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=instantiated" \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Channels"
echo
curl -s -X GET \
  "http://localhost:4000/channels?peer=peer1" \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."

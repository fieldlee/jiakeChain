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

echo "POST request Enroll on Seller  ..."
echo
Jiake_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=seller&password=password&orgName=Seller')
echo $Jiake_TOKEN
Jiake_TOKEN=$(echo $Jiake_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $Jiake_TOKEN"
echo
echo "POST request Enroll on Seller ..."
echo

echo "POST request Join channel on Seller"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/peers \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "orgname":"Seller",
	"peers": ["peer1","peer2"]
}'
echo
echo


echo "POST Install chaincode on Seller"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"hlccc",
	"chaincodeVersion":"v1.0"
}'
echo
echo

# echo "POST instantiate chaincode on peer1 of Seller"
# echo
# curl -s -X POST \
#   http://localhost:4000/channels/jiakechannel/chaincodes \
#   -H "authorization: Bearer $Jiake_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
# 	"chaincodeName":"hlccc",
# 	"chaincodeVersion":"v1.0",
# 	"args":[]
# }'
# echo
# echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

echo "POST request Enroll on Jiake  ..."
echo
Jiake_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=jiake&password=password&orgName=Jiake')
echo $Jiake_TOKEN
Jiake_TOKEN=$(echo $Jiake_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $Jiake_TOKEN"
echo
echo "POST request Enroll on Creator ..."
echo
Creator_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=creator&password=password&orgName=Creator')
echo $Creator_TOKEN
Creator_TOKEN=$(echo $Creator_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Creator token is $Creator_TOKEN"
echo
echo "POST request Enroll on Transfer ..."
echo
Transfer_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=transfer&password=password&orgName=Transfer')
echo $Transfer_TOKEN
Transfer_TOKEN=$(echo $Transfer_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Transfer token is $Transfer_TOKEN"
echo
echo "POST request Enroll on Transfer ..."
echo
Seller_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=seller&password=password&orgName=Seller')
echo $Seller_TOKEN
Seller_TOKEN=$(echo $Seller_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Seller token is $Seller_TOKEN"
echo


echo "POST Install chaincode on Jiake"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"hlccc",
	"chaincodeVersion":"v2.4"
}'
echo
echo


echo "POST Install chaincode on Creator"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Creator_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"hlccc",
	"chaincodeVersion":"v2.4"
}'
echo
echo

echo "POST Install chaincode on Transfer"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Transfer_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"hlccc",
	"chaincodeVersion":"v2.4"
}'
echo
echo

echo "POST Install chaincode on Seller"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Seller_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"hlccc",
	"chaincodeVersion":"v2.4"
}'
echo
echo


echo "POST upgrade chaincode on peer1 of Jiake"
echo
curl -s -X PUT \
  http://localhost:4000/channels/jiakechannel/chaincodes \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"hlccc",
	"chaincodeVersion":"v2.4",
  "args":[]
}'
echo
echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."

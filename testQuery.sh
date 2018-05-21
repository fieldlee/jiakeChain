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
echo "ORG Jiake token is $Jiake_TOKEN"
echo


echo "POST invoke chaincode on peers of Jiake and Creator"
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/chaincodes/hlccc \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"move",
	"args":["a","b","10"]
}')
echo "Transacton ID is $TRX_ID"
echo


echo "GET query chaincode on peer1 of Jiake"
echo
curl -s -X GET \
  "http://localhost:4000/channels/jiakechannel/chaincodes/hlccc?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
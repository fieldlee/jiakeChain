jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

ChannelName="jiakechannel"
Version="v1.1"
echo "POST request Enroll on Jiake  ..."
echo
Nxia_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=nxia&password=password&orgName=Nxia')
echo $Nxia_TOKEN
Nxia_TOKEN=$(echo $Nxia_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Nxia token is $Nxia_TOKEN"
echo
echo "POST request Enroll on Nmen ..."
echo
Nmen_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=nmen&password=password&orgName=Nmen')
echo $Nmen_TOKEN
Nmen_TOKEN=$(echo $Nmen_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Nmen token is $Nmen_TOKEN"
echo
echo "POST request Enroll on dubai ..."
echo
Dubai_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=dubai&password=password&orgName=Dubai')
echo $Dubai_TOKEN
Dubai_TOKEN=$(echo $Dubai_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "dubai token is $Dubai_TOKEN"
echo
echo "POST request Enroll on manager ..."
echo
Manager_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=seller&password=password&orgName=Manager')
echo $Manager_TOKEN
Manager_TOKEN=$(echo $Manager_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Manager token is $Manager_TOKEN"
echo


echo "POST Install chaincode on Nxia"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Nxia_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"jiakechaincode",
	"chaincodePath":"jiakechaincode",
	"chaincodeVersion":"v1.1"
}'
echo
echo


echo "POST Install chaincode on nMEN"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Nmen_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"jiakechaincode",
	"chaincodePath":"jiakechaincode",
	"chaincodeVersion":"v1.1"
}'
echo
echo

echo "POST Install chaincode on Dubai"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Dubai_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"jiakechaincode",
	"chaincodePath":"jiakechaincode",
	"chaincodeVersion":"v1.1"
}'
echo
echo

echo "POST Install chaincode on Manager"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Manager_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"jiakechaincode",
	"chaincodePath":"jiakechaincode",
	"chaincodeVersion":"v1.1"
}'
echo
echo


echo "POST upgrade chaincode on peer1 of Nxia"
echo
curl -s -X PUT \
  http://localhost:4000/channels/jiakechannel/chaincodes \
  -H "authorization: Bearer $Manager_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"jiakechaincode",
	"chaincodeVersion":"v1.1",
  "args":[]
}'
echo
echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."

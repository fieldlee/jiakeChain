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


echo "POST request Join channel on Jiake"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/peers \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo

echo "POST request Join channel on Creator"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/peers \
  -H "authorization: Bearer $Creator_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
  }'
echo
echo


echo "POST request Join channel on Transfer"
echo
curl -s -X POST \
  http://localhost:4000/channels/jiakechannel/peers \
  -H "authorization: Bearer $Transfer_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
  }'
echo
echo

echo "Join Channel execution time : $(($(date +%s)-starttime)) secs ..."
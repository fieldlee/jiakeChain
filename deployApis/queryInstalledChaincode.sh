

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
echo "Jiake token is $Jiake_TOKEN"
echo
echo "GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=installed" \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "GET query Instantiated chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=instantiated" \
  -H "authorization: Bearer $Jiake_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "Join Channel execution time : $(($(date +%s)-starttime)) secs ..."
#/bin/bash

# Ensure necessary tools are installed
sudo apt-get update
sudo apt-get install -y jq curl
sudo apt-get install -y nodejs

DEVICE_ID="ENTER DEVICE ID HERE"
DEVICE_KEY="ENTER DEVICE SYM KEY HERE"
SCOPE="ENTER SCOPE ID HERE"

function getAuth {
  # A node script that prints an auth signature using SCOPE, DEVICE_ID and DEVICE_KEY
  AUTH=`node -e "\
  const crypto   = require('crypto');\

  function computeDrivedSymmetricKey(masterKey, regId) {\
    return crypto.createHmac('SHA256', Buffer.from(masterKey, 'base64'))\
      .update(regId, 'utf8')\
      .digest('base64');\
  }\
  \
  var expires = parseInt((Date.now() + (7200 * 1000)) / 1000);\
  var sr = '${SCOPE}%2f${TARGET}%2f${DEVICE_ID}';\
  var sigNoEncode = computeDrivedSymmetricKey('${DEVICE_KEY}', sr + '\n' + expires);\
  var sigEncoded = encodeURIComponent(sigNoEncode);\
  console.log('SharedAccessSignature sr=' + sr + '&sig=' + sigEncoded + '&se=' + expires)\
  "`
}

SCOPEID="$SCOPE"
TARGET="registrations"
# get auth for Azure IoT DPS service
getAuth

# use the Auth and make a PUT request to Azure IoT DPS service
OUT=`curl \
  -H "authorization: ${AUTH}&skn=registration" \
  -H 'content-type: application/json; charset=utf-8' \
  -s \
  --request PUT --data "{\"registrationId\":\"$DEVICE_ID\"}" "https://global.azure-devices-provisioning.net/$SCOPEID/registrations/$DEVICE_ID/register?api-version=2018-11-01"`

OPERATION=`node -e "c=JSON.parse('$OUT');if(c.errorCode){console.log(c);process.exit(1);}console.log(c.operationId)"`

if [[ $? != 0 ]]; then
  # if there was an error, print the stdout part and exit
  echo "$OPERATION"
  exit
else
  echo "Authenticating.."
  # wait 2 secs before making the GET request to Azure IoT DPS service
  sleep 2

  OUT=`curl -s \
  -H "authorization: ${AUTH}&skn=registration" \
  -H "content-type: application/json; charset=utf-8" \
  --request GET "https://global.azure-devices-provisioning.net/$SCOPEID/registrations/$DEVICE_ID/operations/$OPERATION?api-version=2018-11-01"`

  # parse the return value from the DPS host and try to grab the assigned hub
  OUT=`node -pe "a=JSON.parse('$OUT');if(a.errorCode){a}else{a.registrationState.assignedHub}"`

  if [[ $OUT =~ 'errorCode' ]]; then
    # if there was an error, print the stdout part and exit
    echo "$OUT"
    exit
  fi

  TARGET="devices"
  SCOPE="$OUT"
  # get Auth for Azure IoThub service
  getAuth

  echo "OK"
  echo

  # Receiving commands from Azure IoT Central
  echo "Listening for commands..."

  # Set the endpoint for receiving commands
  COMMANDS_ENDPOINT="https://$SCOPE/devices/$DEVICE_ID/messages/devicebound?api-version=2021-04-12"

  # Polling for commands (you may want to implement a more efficient listener)
  while true; do
    # Get the commands from Azure IoT Central and capture headers
    COMMAND_RESPONSE=$(curl -s -D - \
      -H "Authorization: ${AUTH}" \
      -H "Content-Type: application/json" \
      --request GET "$COMMANDS_ENDPOINT")

    # Extract the etag from the headers
    ETAG=$(echo "$COMMAND_RESPONSE" | grep -i "etag:" | awk '{print $2}' | tr -d '\r')
    echo "---------- Etag ---------------"
	echo $ETAG
	echo "-------------------------------"
    # Extract the body of the command response
    COMMAND_BODY=$(echo "$COMMAND_RESPONSE" | sed -n '/^\r$/,$p' | tail -n +2)
    echo "--------- Body ----------------"
	echo COMMAND_BODY
	echo "-------------------------------"
    echo "Command received: $COMMAND_BODY"

    if [ -n "$COMMAND_BODY" ]; then

      # Prepare the response payload
      RESPONSE_PAYLOAD="{\"status\": \"success\", \"methodName\": \"$METHOD_NAME\"}"

      # Send the response back to Azure IoT Central using the new endpoint
      #curl -s \
      #  -H "Authorization: ${AUTH}" \
      #  -H "Content-Type: application/json" \
      #  --request POST \
      #  --data "$RESPONSE_PAYLOAD" \
      #  "https://$SCOPE/devices/$DEVICE_ID/messages/deviceBound/$ETAG?api-version=2021-04-12"
      
	  curl -v  -s \
  -H "authorization: ${AUTH}&skn=registration" \
  -H "content-type: application/json; charset=utf-8" \
  --request DELETE "https://global.azure-devices-provisioning.net/devices/$DEVICE_ID/messages/deviceBound/$ETAG?api-version=2021-04-12"

    fi

    # Sleep for a while before polling again
    sleep 1
  done

fi

echo

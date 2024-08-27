#!/bin/bash

# Ensure necessary tools are installed
sudo apt-get update
sudo apt-get install -y jq curl

# Define variables
IOT_HUB_NAME="<Your IoT Hub Name>"
DEVICE_ID="<Your Device ID>"
SAS_TOKEN="<Your SAS Token>"
DHT_PIN=4  # GPIO pin where the DHT11 is connected

# Function to read temperature from DHT11 sensor
read_temperature() {
    # Use Adafruit DHT library to read temperature
    TEMP=$(python3 -c "
import Adafruit_DHT
sensor = Adafruit_DHT.DHT11
pin = $DHT_PIN
humidity, temperature = Adafruit_DHT.read(sensor, pin)
if temperature is not None:
    print(temperature)
else:
    print('Error')
")
    echo $TEMP
}

# Function to send telemetry data to Azure IoT Central
send_telemetry() {
    local temperature=$1
    local payload="{\"temperature\": $temperature}"
    curl -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: SharedAccessSignature sr=$SCOPE_ID%2Fdevices%2F$DEVICE_ID&sig=$(echo -n "$payload" | openssl dgst -sha256 -hmac "$SCOPE_ID" | sed 's/^.* //')&se=$(date -u +%s --date='1 hour')" \
        -d "$payload" \
        "https://$IOT_CENTRAL_APP_ID.azureiotcentral.com/api/v3/devices/$DEVICE_ID/telemetry"
}

# Main loop to read temperature and send telemetry every 60 seconds
while true; do
    temperature=$(read_temperature)
    if [[ $temperature != "Error" ]]; then
        send_telemetry $temperature
        echo "Sent temperature: $temperature"
    else
        echo "Failed to read temperature"
    fi
    sleep 60
done

# AirConditionIoTCentral
This project allows you to control Air Conditioning using Azure IoT Central.
Commands to Air Conditioning will be sent via Infrared (first we record them from the original Remote Controller).

# Prerequisites
Install and customize (connect to network) your Raspberry Pi. Any Zero, Zero W, 1A+, 1B+, 2B, 3B, 3B+, 3A+, 4B, 400, CM1, CM3, CM3+, CM4, CM4S, Zero 2 W are supported. The best way is to use Raspberry Pi Imager https://www.raspberrypi.com/software/.


## No wireless interface found
In case of use USB Realtek or similar WiFi, use the Raspberry Pi OS with desktop Image (Debian version: 12 (bookworm).

# Hardware
We will be using the following additional eqipment. Th equipment is well known, and can be used a similar.

## Temperature and humidity sensor DHT11 - module + wires
We will be using it simple to get the temperature, so base on it we will know if Air Condition is working or not.
https://botland.store/multifunctional-sensors/1886-temperature-and-humidity-sensor-dht11-module--5903351242448.html
https://www.anodas.lt/en/dht11-module-arduino-temperature-and-humidity-sensor

## IR receiver + wire - Iduino SE027
We will be using it to recod the sequences (butteons) from orginal remote controller.
https://botland.store/ir-receivers/14283-ir-receiver-wire-iduino-se027-5903351242165.html
https://www.anodas.lt/en/ir-receiver-cable-iduino-se027

## IR 940nm transmitter + wire - Iduino SE028
The main component via this one we will send InfraRed commands to Air Conditioner.
https://botland.store/led-ir-infrared/14286-ir-940nm-transmitter-wire-iduino-se028-5903351242011.html
https://www.anodas.lt/en/ir-940nm-transmitter-wire-iduino-se028?search=Iduino%20SE028


## Appendix 01 - IoT Central sample project
https://github.com/gloveboxes/Create-RaspberryPi-dotNET-Core-C-Sharp-IoT-Applications/tree/master/labs/Lab_2_Azure_IoT_Central

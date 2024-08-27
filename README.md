# AirConditionIoTCentral

This project allows you to control air conditioning using Azure IoT Central. Commands to the air conditioning unit will be sent via infrared (first, we record them from the original remote controller).

## Prerequisites

Install and customize (connect to the network) your Raspberry Pi. Any of the following models are supported: Zero, Zero W, 1A+, 1B+, 2B, 3B, 3B+, 3A+, 4B, 400, CM1, CM3, CM3+, CM4, CM4S, Zero 2 W. The best way is to use the Raspberry Pi Imager: [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

## No Wireless Interface Found

In case you use a USB Realtek or similar WiFi adapter, use the Raspberry Pi OS with desktop image (Debian version: 12 (bookworm)).

## Hardware

We will be using the following additional equipment. The equipment is well known and can be substituted with similar items.

### Temperature and Humidity Sensor DHT11 - Module + Wires

We will be using it simply to get the temperature, so based on it we will know if the air conditioner is working or not.
- [Botland Store](https://botland.store/multifunctional-sensors/1886-temperature-and-humidity-sensor-dht11-module--5903351242448.html)
- [Anodas](https://www.anodas.lt/en/dht11-module-arduino-temperature-and-humidity-sensor)

### IR Receiver + Wire - Iduino SE027

We will be using it to record the sequences (buttons) from the original remote controller.
- [Botland Store](https://botland.store/ir-receivers/14283-ir-receiver-wire-iduino-se027-5903351242165.html)
- [Anodas](https://www.anodas.lt/en/ir-receiver-cable-iduino-se027)

### IR 940nm Transmitter + Wire - Iduino SE028

The main component via which we will send infrared commands to the air conditioner.
- [Botland Store](https://botland.store/led-ir-infrared/14286-ir-940nm-transmitter-wire-iduino-se028-5903351242011.html)
- [Anodas](https://www.anodas.lt/en/ir-940nm-transmitter-wire-iduino-se028?search=Iduino%20SE028)

## Azure IoT Central

See the Appendix 01 - IoT Central Sample Project to get knowedgle about the 

## Appendix 01 - IoT Central Sample Project

[IoT Central Sample Project](https://github.com/gloveboxes/Create-RaspberryPi-dotNET-Core-C-Sharp-IoT-Applications/tree/master/labs/Lab_2_Azure_IoT_Central)

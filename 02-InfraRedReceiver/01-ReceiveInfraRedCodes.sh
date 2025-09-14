#!/bin/bash


sudo apt update
sudo apt-get install -y lirc

# Overwrite /etc/lirc/hardware.conf
sudo tee /etc/lirc/hardware.conf > /dev/null <<EOF

LIRCD_ARGS="--uinput --listen"
LOAD_MODULES=true
DRIVER="default"
DEVICE="/dev/lirc0"
MODULES="lirc_rpi"
EOF

# Append to /boot/firmware/config.txt
sudo tee -a /boot/firmware/config.txt > /dev/null <<EOF
dtoverlay=pwm-ir-tx,gpio_pin=18
dtoverlay=gpio-ir,gpio_pin=22
EOF

# Set default device
sudo tee -a /etc/lirc/lirc_options.conf > /dev/null <<EOF

driver    = default
device    = /dev/lirc0
EOF



sudo /etc/init.d/lircd stop
sudo /etc/init.d/lircd start
sudo /etc/init.d/lircd status
sudo /etc/init.d/lircd stop
sudo reboot

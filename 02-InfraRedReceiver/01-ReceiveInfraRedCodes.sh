#!/bin/bash

#https://gist.github.com/prasanthj/c15a5298eb682bde34961c322c95378b

sudo apt update
sudo apt-get install -y lirc

# Append to /etc/modules
sudo tee -a /etc/modules > /dev/null <<EOF
lirc_dev
lirc_rpi gpio_in_pin=27 gpio_out_pin=22
EOF

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
dtoverlay=gpio-ir,gpio_pin=27
EOF

# Not sure about this section
sudo tee -a /etc/lirc/lirc_options.conf > /dev/null <<EOF

driver    = default
device    = /dev/lirc0
EOF



sudo /etc/init.d/lircd stop
sudo /etc/init.d/lircd start
sudo /etc/init.d/lircd status

sudo /etc/init.d/lircd stop
mode2 -d /dev/lirc0

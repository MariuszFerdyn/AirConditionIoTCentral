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

########################################################
# /etc/lirc/hardware.conf
#
# Arguments which will be used when launching lircd
LIRCD_ARGS="--uinput"

# Don't start lircmd even if there seems to be a good config file
# START_LIRCMD=false

# Don't start irexec, even if a good config file seems to exist.
# START_IREXEC=false

# Try to load appropriate kernel modules
LOAD_MODULES=true

# Run "lircd --driver=help" for a list of supported drivers.
DRIVER="default"
# usually /dev/lirc0 is the correct setting for systems using udev
DEVICE="/dev/lirc0"
MODULES="lirc_rpi"

# Default configuration files for your hardware if any
LIRCD_CONF=""
LIRCMD_CONF=""
######################################################## 
EOF

# Append to /boot/config.txt
sudo tee -a /boot/config.txt > /dev/null <<EOF

dtoverlay=lirc-rpi,gpio_in_pin=27,gpio_out_pin=22
EOF


sudo /etc/init.d/lirc stop
sudo /etc/init.d/lirc start

sudo /etc/init.d/lirc stop
mode2 -d /dev/lirc0

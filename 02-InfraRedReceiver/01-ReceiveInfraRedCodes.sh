#/bin/bash

sudo apt update
sudo apt install -y ir-keytable


sudo echo "dtoverlay=gpio-ir,gpio_pin=13 # PINN not GPIO for receiving data" >> /boot/config.txt
sudo echo "dtoverlay=gpio-ir-tx,gpio_pin=15 # PINN not GPIO for sending commands" > /boot/config.txt
echo "After Reboot execute sudo ir-keytable -c -p all -t to listen IR"
sudo reboot now

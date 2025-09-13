#!/bin/bash

#https://gist.github.com/prasanthj/c15a5298eb682bde34961c322c95378b

sudo apt update
sudo apt-get install -y lirc

# Append to /etc/modules (not needed anymore)
# sudo tee -a /etc/modules > /dev/null <<EOF
#lirc_dev
#lirc_rpi gpio_in_pin=27 gpio_out_pin=22
#EOF

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
#mode2 -d /dev/lirc0
#mode2 -H default -d /dev/lirc0

ir-ctl -r       # And press on Remote control button to learn the codes to send - you shoud receive something like:
                # mf@pi1:~/AirConditionIoTCentral/02-InfraRedReceiver $ ir-ctl -r
                # +8984 -4465 +612 -1634 +617 -1634 +617 -506 +619 -502 +616 -507 +617 -506 +616 -1645 +608


ir-ctl -ron.ir    # And press on Remote control button to learn the codes to send - repeat every button you want to program. - commands will be stored in on.ir file
ir-ctl -roff.ir   # And press on Remote control button to learn the codes to send - repeat every button you want to program. - commands will be stored in off.ir file In that case I record on and off.

# Configure for sending
echo "=== Setting up IR TX (/dev/lirc1) on GPIO 22 ==="

TX_OVERLAY_LINE="dtoverlay=gpio-ir-tx,gpio_pin=22"
CONFIG_FILE="/boot/firmware/config.txt"

# Append transmit overlay if not already present
if ! grep -q "^${TX_OVERLAY_LINE}" "${CONFIG_FILE}" 2>/dev/null; then
  echo "${TX_OVERLAY_LINE}" | sudo tee -a "${CONFIG_FILE}"
  TX_OVERLAY_ADDED=1
  echo "Added ${TX_OVERLAY_LINE} to ${CONFIG_FILE}"
else
  echo "Transmit overlay already present in ${CONFIG_FILE}"
fi

# Warn about potential conflict with legacy lirc_rpi usage
if grep -q "lirc_rpi" /etc/modules 2>/dev/null; then
  echo "NOTE: You still load lirc_rpi via /etc/modules. If /dev/lirc1 does not appear after reboot,"
  echo "      consider editing /etc/modules to remove the lirc_rpi line and rely only on the gpio-ir / gpio-ir-tx overlays."
fi

# If we just added the overlay, we need a reboot before /dev/lirc1 will exist
if [ "${TX_OVERLAY_ADDED}" = "1" ]; then
  echo "Reboot required for /dev/lirc1 to appear. Run: sudo reboot"
else
  # If already present, check if device node exists now
  if [ -e /dev/lirc1 ]; then
    echo "/dev/lirc1 already present."
  else
    echo "/dev/lirc1 not present yet. If first time enabling, reboot is still required."
  fi
fi


#Now lets test if we can send codes
ir-ctl -son.ir    # We are sending on message via IR - so IR receiver in that case should be on
ir-ctl -soff.ir   #We are sending on message via IR - so IR receiver in that case should be off

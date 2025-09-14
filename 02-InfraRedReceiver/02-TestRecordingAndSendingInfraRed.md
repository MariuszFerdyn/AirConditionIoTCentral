
ir-ctl -f -d /dev/lirc0      # Display information about lirc0 interface - observer which one is for receiving, which one is for sending
ir-ctl -f -d /dev/lirc1      # Display information about lirc1 interface - observer which one is for receiving, which one is for sending

ir-ctl -r       # And press on Remote control button to learn the codes to send - you shoud receive something like:
                # mf@pi1:~/AirConditionIoTCentral/02-InfraRedReceiver $ ir-ctl -r
                # +8984 -4465 +612 -1634 +617 -1634 +617 -506 +619 -502 +616 -507 +617 -506 +616 -1645 +608


ir-ctl -ron.ir    # And press on Remote control button to learn the codes to send - repeat every button you want to program. - commands will be stored in on.ir file
ir-ctl -roff.ir   # And press on Remote control button to learn the codes to send - repeat every button you want to program. - commands will be stored in off.ir file In that case I record on and off.

#Now lets test if we can send codes
ir-ctl -son.ir    # We are sending on message via IR - so IR receiver in that case should be on
ir-ctl -soff.ir   #We are sending on message via IR - so IR receiver in that case should be off

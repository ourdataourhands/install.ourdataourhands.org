#!/bin/bash
#
# Our Data Our Hands onboot
#

# Vars
log="/home/pi/boot.log"
riseup="/mnt/storage/docker/riseup.sh"

# Log the start
dt="$(date)"
echo "$dt" > $log

# Phone home
curl http://sh.ourdataourhands.org/beacon.sh | bash -s boot

# Updates
sudo apt-get update >> $log
sudo apt-get dist-upgrade >> $log
sudo apt-get clean >> $log

# Rise up!
if [[ -f "$riseup" ]]; then
	echo "Run $riseup..." >> $log
	sudo bash $riseup
else
	echo "$riseup not found" >> $log
fi
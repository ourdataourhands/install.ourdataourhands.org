#!/bin/bash
#
# Our Data Our Hands onboot
#
# Runs using curl|bash in the rc.local file on boot.
#
# Report bugs here:
# https://github.com/ourdataourhands/sh.ourdataourhands.org
#

# Vars
log="/home/pi/boot.log"
riseup="/mnt/storage/docker/riseup.sh"

# Log the start
dt="$(date)"
echo "$dt" > $log

# Phone home
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s boot

# Updates
echo "Running updates..."
sudo apt-get update >> $log
sudo apt-get dist-upgrade >> $log
sudo apt-get clean >> $log

# Rise up!
echo "Rising up..."
if [[ -f "$riseup" ]]; then
	echo "Run $riseup..." >> $log
	sudo bash $riseup purge
else
	echo "$riseup not found" >> $log
fi
#!/bin/bash
#
# Our Data Our Hands onboot
#

# Phone home
curl http://sh.ourdataourhands.org/beacon.sh | bash -s boot

# Vars
log="~/boot.log"
riseup="/mnt/storage/docker/riseup.sh"
touch $log

# Updates
sudo apt-get update >> $log
sudo apt-get dist-upgrade >> $log
sudo apt-get clean >> $log

# Rise up!
if [[ -f "$riseup" ]]; then
	sudo bash $riseup
else
	echo "$riseup not found" >> $log
fi
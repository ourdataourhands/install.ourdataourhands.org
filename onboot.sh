#!/bin/bash
#
# Our Data Our Hands onboot
#

# Phone home
curl http://sh.ourdataourhands.org/beacon.sh | bash -s boot

# Vars
log="~/boot.log"
riseup="/mnt/storage/docker/riseup.sh"

# Updates
apt-get update > $log
apt-get dist-upgrade >> $log
sudo apt-get clean >> $log

# Rise up!
if [[ -f "$riseup" ]]; then
	bash $riseup
else
	echo "$riseup not found" >> $log
fi
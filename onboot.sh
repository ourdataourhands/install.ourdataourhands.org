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
rpath="/mnt/storage/docker"
riseup="$rpath/riseup.sh"
firstboot="/boot/firstboot"

# Log the start
dt="$(date)"
echo "$dt" > $log

# Phone home
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s boot

# Updates
echo "Running updates..." >> $log
sudo apt-get update -y >> $log
sudo apt-get dist-upgrade -y >> $log
sudo apt-get clean -y >> $log

# First boot install ODOH
echo "First boot...  " >> $log
if [[ -f "$firstboot" ]]; then
	echo "yes, install!" >> $log
	sudo rm -f $firstboot
	curl -s http://sh.ourdataourhands.org/install.sh | bash
	exit 1;
else
	echo "nope, continue..." >> $log
fi

# Rise up!
echo "Rising up..." >> $log
if [[ -f "$riseup" ]]; then
	cd $rpath
	echo "Update..." >> $log
	git pull
	echo "Run $riseup..." >> $log
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash
	sudo bash $riseup purge
else
	echo "$riseup not found" >> $log
fi

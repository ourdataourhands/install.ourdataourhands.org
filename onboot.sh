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
username="/mnt/storage/username"

# Log the start
dt="$(date)"
echo "$dt" > $log

# Updates
echo "Running updates..." >> $log
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s updates-on-boot
sudo apt-get update -y >> $log
sudo apt-get dist-upgrade -y >> $log
sudo apt-get clean -y >> $log

# First boot install ODOH
echo "First boot...  " >> $log
if [[ -f "$firstboot" ]]; then
	echo "yes, install!" >> $log
	sudo rm -f $firstboot
	# Phone home
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s firstboot
	# Install
	curl -s http://sh.ourdataourhands.org/install.sh | bash
	exit 1;
else
	echo "nope, continue..." >> $log
	# Phone home
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s boot
fi

# Set hostname
if [[ -f "$username" ]]; then
	echo "Checking hostname... " >> $log
	hn="$(sudo hostname)"
	echo "Current hostname: $hn" >> $log
	un="$(sudo cat $username)"
	if [[ "$hn" != "$un" ]]; then
		echo "New hostname: $un" >> $log
		hnchange="$(sudo cat $un > /etc/hostname)"
		echo "$hnchange" >> $log
		curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s change-to-$un
		#sudo reboot
	else
		echo "No change." >> $log
	fi
fi

# Rise up!
echo "Rising up..." >> $log
if [[ -f "$riseup" ]]; then
	cd $rpath
	echo "Update..." >> $log
	git pull
	echo "Run $riseup..." >> $log
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s riseup
	sudo bash $riseup purge
else
	echo "$riseup not found" >> $log
fi

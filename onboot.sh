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
echo "Start $dt" > $log

# Updates
echo "Running updates..." >> $log
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s updates-on-boot
sudo apt-get update -y >> $log
sudo apt-get dist-upgrade -y >> $log
sudo apt-get clean -y >> $log

# First boot?
if [[ -f "$firstboot" ]]; then
	echo "My first time, install! :)" >> $log
	sudo rm -f $firstboot
	# Phone home
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s firstboot
	# Install
	curl -s http://sh.ourdataourhands.org/install.sh | bash
else
	# Phone home
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s boot
	# Rise up!
	if [[ -f "$riseup" ]]; then
		cd $rpath
		echo "Pull the latest code into $rpath" >> $log
		git pull
		echo "RISE UP!" >> $log
		# Phone home
		curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s riseup
		bash $riseup purge
	else
		echo "$riseup not found, stop." >> $log
		exit 0;
	fi
fi

	
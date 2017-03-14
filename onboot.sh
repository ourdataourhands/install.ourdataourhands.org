#!/bin/bash
#
# Our Data Our Hands onboot
#
# Runs using curl|bash in the rc.local file on boot.
#
# Report bugs here:
# https://github.com/ourdataourhands/sh.ourdataourhands.org
#
# Logging
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>~/boot.log 2>&1

# Vars
rpath="/mnt/storage/docker"
riseup="$rpath/riseup.sh"
firstboot="/boot/firstboot"
username="/mnt/storage/username"

# Log the start
dt="$(date)"
echo "Start $dt"

# Update the time
sudo /usr/sbin/ntpdate -s 0.ca.pool.ntp.org

# Updates
echo "Running updates..."
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s updates-on-boot
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get clean -y

# First boot?
if [[ -f "$firstboot" ]]; then
	echo "My first time, install! :)"
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
		echo "Pull the latest code into $rpath"
		git pull
		echo "RISE UP!"
		# Phone home
		curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s riseup
		bash $riseup purge
	else
		echo "$riseup not found, stop."
		exit 0;
	fi
fi

	
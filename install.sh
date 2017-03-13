#!/bin/bash
#
# Our Data Our Hands install script
#
# This script tries to setup a working Docker image on the ODOH Zerotier
# network that contributes storage space.
#
# Report bugs here:
# https://github.com/ourdataourhands/sh.ourdataourhands.org
#
# Logging
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>~/install.log 2>&1

echo
echo '*** Our Data Our Hands install script for Linux like systems'
echo '*** Support is limited to Debian on x86_64 and Raspbian on ARM'
echo
echo '*** Please report any bugs you find here:'
echo '*** https://github.com/ourdataourhands/sh.ourdataourhands.org'
echo
echo

# Check to see we have elevated permissions
SUDO=
if [ "$UID" != "0" ]; then
	if [ -e /usr/bin/sudo -o -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo
		echo
		echo '*** This installer script requires root privileges.'
		echo
		echo
		exit 0
	fi
fi

# Check if docker is installed
docker_installed=$(docker -v | grep "Docker version")
if [[ -z "$docker_installed" ]]; then
	echo "Docker not found: please install docker to continue."
	exit 0
else
	echo "Found $docker_installed"
fi

# Check for OpenSSL
openssl_installed=$(openssl version | grep "OpenSSL ")
if [[ -z "$openssl_installed" ]]; then
	echo "OpenSSL not found: please install OpenSSL to continue."
	exit 0
else
	echo "Found $openssl_installed"
fi

# Check for git
git_installed=$(git --version | grep "git version ")
if [[ -z "$git_installed" ]]; then
	echo "git not found: please install git to continue."
	exit 0
else
	echo "Found $git_installed"
fi

# Install path
install_path="/mnt/storage"

# Check if a drive is mounted at /mnt/storage
storage_mounted=$(df -h | grep "$install_path")
if [[ -z "$storage_mounted" ]]; then
	echo "Drive not found: please mount a massive drive at $install_path to continue."
	exit 0
else
	echo "Found contributing path: $install_path"
fi

# Capacity of storage, as per argument
if [[ ! -z "$1" ]]; then
	echo "$1" > "$install_path/root/capacity"
	echo "Allocated $1 for node contribution"
fi

# Capacity to allocate to the grid by default
if [[ ! -f "$install_path/root/capacity" ]]; then
	echo "4600GB" > "$install_path/root/capacity"
	echo "Allocated default amount of 4.6TB for node contribution"
fi

# Storage pod docker repo
if [ -d "$install_path/docker/.git" ]; then
	echo "Found ODOH docker repo, pulling latest"
	git -C "$install_path/docker/" pull
else
	echo "Cloning ODOH docker repo"
	git clone https://github.com/ourdataourhands/storage-pod-docker.git "$install_path/docker"
fi

# infinit storage
if [ ! -d "$install_path/root/.local" ]; then
	mkdir -p "$install_path/root/.local"
	echo "Created $install_path/root/.local for infinit"
fi

# Zerotier configuration
if [ ! -d "$install_path/zerotier-one" ]; then
	mkdir -p "$install_path/zerotier-one"
	echo "Created $install_path/zerotier-one for Zerotier network"
fi

# Logs
if [ ! -d "$install_path/root/logs" ]; then
	mkdir -p "$install_path/root/logs" && touch "$install_path/root/logs/pod-setup.log"
	echo "Created $install_path/root/logs"
fi

# Come up with a random, unique name
if [ ! -f "$install_path/root/username" ]; then
	dockname=$(curl -s https://frightanic.com/goodies_content/docker-names.php | tr _ -)
	hexstr=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 6)
	username="io-odoh-pod-${dockname}-${hexstr}"
	echo $username > "$install_path/root/username"
	echo "Named you! You shall be known as $username"
	# Provision this user please
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s provision--$username
	# Set hostname
	$SUDO cp "$install_path/root/username" /etc/hostname
	echo "127.0.1.1	 $username" > /tmp/hostline
	cat /etc/hosts /tmp/hostline > /tmp/hosts
	$SUDO cp /tmp/hosts /etc/hosts 
	$SUDO /etc/init.d/hostname.sh stop
	$SUDO /etc/init.d/hostname.sh start
	curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s change-to--$username

fi

# Keys
if [ ! -d "$install_path/root/.ssh" ]; then
	echo -n "Generating keys... "
	mkdir -p "$install_path/root/.ssh" && ssh-keygen -q -t rsa -N "" -f "$install_path/root/.ssh/id_rsa" -C $username
	echo "done."
	# Some Symlinks
	echo -n "Symlinks... "
	ln -s "/home/pi/.odohid" "$install_path/root/.odohid"
	echo "done."
fi

# Riseup!
cd "$install_path/docker"
echo "RISE UP!"
bash riseup.sh purge

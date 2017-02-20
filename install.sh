#!/bin/bash
#
# Our Data Our Hands install script
#
# This script tries to setup a working Docker image on the ODOH Zerotier
# network that contributes storage space. If you find anything wrong with
# this script, please contact us and we will fix ASAP:
#
#	https://ourdataourhands.org/
#	riseup@ourdataourhands.org
#

echo
echo '*** Our Data Our Hands install script for Linux like systems'
echo '*** Initial support is limited to Debian on x86_64 and arm'
echo
echo '*** Please report issues to riseup@ourdataourhands.org'
echo '*** or use the github issue tracker located here https://git.io/vDd6D'
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
docker_installed=$($SUDO docker -v | grep "Docker version")
if [[ -z "$docker_installed" ]]; then
	echo "Docker not found: please install docker to continue."
	exit 0
else
	echo "Found $docker_installed"
fi

# Check for OpenSSL
openssl_installed=$($SUDO openssl version | grep "OpenSSL ")
if [[ -z "$openssl_installed" ]]; then
	echo "OpenSSL not found: please install OpenSSL to continue."
	exit 0
else
	echo "Found $openssl_installed"
fi

# Check for git
git_installed=$($SUDO git --version | grep "git version ")
if [[ -z "$git_installed" ]]; then
	echo "git not found: please install git to continue."
	exit 0
else
	echo "Found $git_installed"
fi

# Install path
install_path="/mnt/storage"

# Check if a drive is mounted at /mnt/storage
storage_mounted=$($SUDO df -h | grep "$install_path")
if [[ -z "$storage_mounted" ]]; then
	echo "Drive not found: please mount a massive drive at $install_path to continue."
	exit 0
else
	echo "Found storage:"
	echo "$storage_mounted"
fi

# Capacity of storage, as per argument
if [[ ! -z "$1" ]]; then
	$SUDO echo "$1" > "$install_path/capacity"
	echo "Allocated $1 for node contribution"
fi

# Capacity to allocate to the grid by default
if [[ ! -f "$install_path/capacity" ]]; then
	$SUDO echo "4.5TB" > "$install_path/capacity"
	echo "Allocated default amount of 4.5TB for node contribution"
fi

# Storage pod docker repo
if [ -d "$install_path/docker/.git" ]; then
	echo "Found ODOH docker repo, pulling latest"
	$SUDO git -C "$install_path/docker/" pull
else
	echo "Cloning ODOH docker repo"
	$SUDO git clone https://github.com/ourdataourhands/storage-pod-docker.git "$install_path/docker"
fi

# infinit storage
if [ ! -d "$install_path/.local" ]; then
	$SUDO mkdir "$install_path/.local"
	echo "Created $install_path/.local for infinit"
fi

# Zerotier configuration
if [ ! -d "$install_path/zerotier-one" ]; then
	$SUDO mkdir "$install_path/zerotier-one"
	echo "Created $install_path/zerotier-one for Zerotier network"
fi

# Logs
if [ ! -d "$install_path/logs" ]; then
	$SUDO mkdir "$install_path/logs" && $SUDO touch "$install_path/logs/pod-setup.log"
	echo "Created $install_path/logs"
fi

# Come up with a random, unique name
if [ ! -f "$install_path/username" ]; then
	dockname=$(curl -s http://frightanic.com/goodies_content/docker-names.php)
	hexstr=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 6)
	username="io.odoh.pod.${dockname}_${hexstr}"
	$SUDO echo $username > "$install_path/username"
	echo "Named you! You shall be known as $username"
fi

# Keys
if [ ! -d "$install_path/id" ]; then
	echo -n "Generating keys... "
	$SUDO mkdir "$install_path/id" && $SUDO ssh-keygen -q -t rsa -N "" -f "$install_path/id/id_rsa" -C $username
	echo "done."
fi

# Riseup!
cd "$install_path/docker"
$SUDO ./riseup.sh

#!/bin/bash

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

echo "Delete /home/pi/.odohid"
$SUDO rm -f /home/pi/.odohid
echo "Delete logs"
$SUDO rm -f /home/pi/*log
echo "Delete drive storage"
$SUDO rm -fr /mnt/storage/*
echo "Create /boot/firstboot"
$SUDO touch /boot/firstboot
echo "Stop docker containers"
$SUDO docker stop $($SUDO docker ps -a -q)
echo "Delete docker containers"
$SUDO docker rm $($SUDO docker ps -a -q)
echo "Delete dangling docker images"
$SUDO docker rmi $($SUDO docker images -f dangling=true -q)
echo "Delete docker images"
$SUDO docker rmi $($SUDO docker images -a -q)
echo "Docker system prune"
$SUDO docker system prune -f
echo "Reset hostname"
$SUDO echo "storagepod" > /tmp/hostname
$SUDO cp /tmp/hostname /etc/hostname

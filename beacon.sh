#!/bin/bash
#
# Our Data Our Hands beacon
#
# A rudimentary attempt at identifying uniquely the storage pod's physical
# hardware so we know how many nodes we have. If you find anything broken in
# this script, please contact us and we will fix ASAP:
#
#	https://ourdataourhands.org/
#	riseup@ourdataourhands.org
#

# ID file
idfile="$HOME/.odohid"

# Check for it
if [[ ! -f "$idfile" ]]; then
	uuidurl="https://www.uuidgenerator.net/api/version4"
	odohid="$(curl -s $uuidurl | tr -d '\r')"
	echo "$odohid" > $idfile
else
	odohid="$(cat $idfile)"
fi

# Timestamp
ts="$(date +"%s")"

# Public IP
ip="$(curl -s https://api.ipify.org/)"

# Hostname
host="$(hostname)"

# Private IP
privateip="$(hostname -I)"

# Geography
geo="$(curl -s https://freegeoip.net/csv/$ip)"

# Event
[ -z "$1" ] && event="ping" || event=$1

# Ping!
url="https://hooks.zapier.com/hooks/catch/2030249/mfl8sm/"
zap="$(curl -s -G ${url} \
	--data-urlencode geo=\"${geo}\" \
	--data-urlencode publicip=${ip} \
	--data-urlencode privateip=${privateip} \
	--data-urlencode timestamp=${ts} \
	--data-urlencode host=${host} \
	--data-urlencode event=${event} \
	--data-urlencode odohid=${odohid})"

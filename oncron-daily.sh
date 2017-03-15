#!/bin/bash
#
# Our Data Our Hands oncron-daily
#
# Runs using curl|bash on a daily basis.
#
# Report bugs here:
# https://github.com/ourdataourhands/sh.ourdataourhands.org
#

# This is just a test
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s crondaily

# Primitive HDD capacity report
hdd="$(df -h |grep mnt/storage)"
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s ${hdd// /_}
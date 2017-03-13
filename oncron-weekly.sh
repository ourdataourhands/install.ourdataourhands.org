#!/bin/bash
#
# Our Data Our Hands oncron weekly
#
# Runs using curl|bash on a weekly basis.
#
# Report bugs here:
# https://github.com/ourdataourhands/sh.ourdataourhands.org
#

# This is just a test
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s cronweekly

sudo reboot
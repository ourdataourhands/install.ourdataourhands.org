#!/bin/bash
#
# Our Data Our Hands oncron hourly
#
# Runs using curl|bash on a hourly basis.
#
# Report bugs here:
# https://github.com/ourdataourhands/sh.ourdataourhands.org
#

# This is just a test
curl -s http://sh.ourdataourhands.org/beacon.sh | bash -s cronhourly

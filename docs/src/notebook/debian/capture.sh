#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/var/run/lightdm/root/${DISPLAY}
export DTSTAMP=$(date "+%Y-%m-%d-%H-%M-%S")

sleep 5
xwd -root > /tmp/lightdm.xwd
convert /tmp/lightdm.xwd /tmp/lightdm-${DTSTAMP}.jpg
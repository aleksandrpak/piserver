#!/bin/sh
set -x

NAS_PASSWORD="$(cat secret.txt)"

ssh admin@192.168.68.75 "echo $NAS_PASSWORD | sudo -S systemctl suspend"

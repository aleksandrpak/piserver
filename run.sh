#!/bin/sh
set -x

# Pi-hole
docker run -d --name pihole \
	-p 53:53/tcp \
	-p 53:53/udp \
	-p 80:80/tcp \
	-e TZ="Europe/Zurich" \
	-e WEBPASSWORD:$WEBPASSWORD \
	-v $HOME/docker/pihole/etc-pihole:/etc/pihole \
	-v $HOME/docker/pihole/etc-dnsmasq.d:/etc/dnsmasq.d \
	--restart=unless-stopped \
	pihole/pihole:latest

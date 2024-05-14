#!/bin/sh
set -x

PASSWORD="$DOCKER_PASSWORD"
TIMEZONE="Europe/Zurich"
DOCKER_DIR="$HOME/docker"
PUID=1000
PGID=1000

# Nginx
docker run -d --name nginx \
	-p 443:443/tcp \
	-p 443:443/udp \
	-p 80:80/tcp \
	-p 80:80/udp \
	-v $DOCKER_DIR/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v $DOCKER_DIR/nginx/cert.pem:/etc/ssl/cert.pem:ro \
	-v $DOCKER_DIR/nginx/key.pem:/etc/ssl/key.pem:ro \
	-v $DOCKER_DIR/nginx/cloudflare.crt:/etc/ssl/cloudflare.crt:ro \
	--restart=unless-stopped \
	nginx:latest

# Pi-hole
docker run -d --name pihole \
	-p 53:53/tcp \
	-p 53:53/udp \
	-p 81:80/tcp \
	-e TZ=$TIMEZONE \
	-e WEBPASSWORD:$PASSWORD \
	-v $DOCKER_DIR/pihole/etc-pihole:/etc/pihole \
	-v $DOCKER_DIR/pihole/etc-dnsmasq.d:/etc/dnsmasq.d \
	--restart=unless-stopped \
	pihole/pihole:latest

# Node-RED
docker run -d --name=nodered \
	-p 1880:1880 \
	-e TZ=$TIMEZONE \
	-v $DOCKER_DIR/nodered/data:/data \
       	--restart=unless-stopped \
	nodered/node-red:latest

# ESPHome
docker run -d --name=esphome \
	-p 6052:6052 \
	-e TZ=$TIMEZONE \
	-e USERNAME=alp \
	-e PASSWORD=$PASSWORD \
	-v $DOCKER_DIR/esphome/config:/config \
	-v /etc/localtime:/etc/localtime:ro \
	--privileged \
	--network=host \
	--restart=unless-stopped \
	ghcr.io/esphome/esphome:latest

# Home assistant
docker run -d --name=homeassistant \
	-p 8123:8123 \
	-e TZ=$TIMEZONE \
	-v $DOCKER_DIR/homeassistant/config:/config \
	--device=/dev/ttyACM0:/dev/ttyACM0 \
	--privileged \
	--network=host \
	--restart=unless-stopped \
	 ghcr.io/home-assistant/home-assistant:latest

# Duplicati
docker run -d --name=duplicati \
	-p 8200:8200 \
	-e TZ=$TIMEZONE \
	-e PUID=$PUID \
	-e PGID=$PGID \
	-v $DOCKER_DIR/duplicati/data:/data \
	-v $DOCKER_DIR:/source \
	--restart=unless-stopped \
	lscr.io/linuxserver/duplicati:latest

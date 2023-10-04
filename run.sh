#!/bin/sh
set -x

PASSWORD="$DOCKER_PASSWORD"
TIMEZONE="Europe/Zurich"
DOCKER_DIR="$HOME/docker"
MEDIA_DIR="/mnt/usb/drive/media"
PUID=1000
PGID=1000

# Pi-hole
docker run -d --name pihole \
	-p 53:53/tcp \
	-p 53:53/udp \
	-p 80:80/tcp \
	-e TZ=$TIMEZONE \
	-e WEBPASSWORD:$WEBPASSWORD \
	-v $DOCKER_DIR/pihole/etc-pihole:/etc/pihole \
	-v $DOCKER_DIR/pihole/etc-dnsmasq.d:/etc/dnsmasq.d \
	--restart=unless-stopped \
	pihole/pihole:latest

# NZB Get
docker run -d --name=nzbget \
	-p 6789:6789 \
	-e PUID=$PUID \
	-e PGID=$PGID \
	-e TZ=$TIMEZONE \
	-e NZBGET_USER=nzbget \
	-e NZBGET_PASS=nzbget \
	-v $DOCKER_DIR/nzbget/config \
	-v $MEDIA_DIR/downloads:/downloads \
	--restart=unless-stopped \
	lscr.io/linuxserver/nzbget:latest

# Sonarr
docker run -d --name=sonarr \
	-p 8989:8989 \
	-e PUID=$PUID \
	-e PGID=$PGID \
	-e TZ=$TIMEZONE \
	-v $DOCKER_DIR/sonarr/config:/config \
	-v $MEDIA_DIR/shows:/tv \
	-v $MEDIA_DIR/downloads:/downloads \
	--restart=unless-stopped \
	--add-host=host.docker.internal:host-gateway \
	lscr.io/linuxserver/sonarr:latest

# Radarr
docker run -d --name=radarr \
	-p 7878:7878 \
	-e PUID=$PUID \
	-e PGID=$PGID \
	-e TZ=$TIMEZONE \
	-v $DOCKER_DIR/radarr/config:/config \
	-v $MEDIA_DIR/movies:/movies \
	-v $MEDIA_DIR/downloads:/downloads \
	--restart=unless-stopped \
	--add-host=host.docker.internal:host-gateway \
	lscr.io/linuxserver/radarr:latest

# Jellyfin
docker run -d --name=jellyfin \
	-p 8096:8096 \
	-p 7359:7359/udp \
	-p 1900:1900/udp \
	-e PUID=$PUID \
	-e PGID=$PGID \
	-e TZ=$TIMEZONE \
	-e JELLYFIN_PublishedServerUrl=192.168.1.15 \
	-v $DOCKER_DIR/jellyfin/config:/config \
	-v $MEDIA_DIR/shows:/tv \
	-v $MEDIA_DIR/movies:/movies \
	--device=/dev/video10:/dev/video10 \
	--device=/dev/video11:/dev/video11 \
	--device=/dev/video12:/dev/video12 \
	--restart unless-stopped \
	lscr.io/linuxserver/jellyfin:latest

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
	 ghcr.io/home-assistant/home-assistant:stable

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

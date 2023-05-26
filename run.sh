#!/bin/sh
set -x

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

# piserver

NOTE: Tested on Raspberry Pi OS 64-bit lite

## Getting started

* Configure SSH in Raspberry Pi imager
* Install everything and get this repo:
  ```shell
  curl -fsSL https://raw.githubusercontent.com/aleksandrpak/piserver/main/install.sh | sudo sh
  ```
* Set environment variables in .bashrc:
  ```shell
  echo "export WEBPASSWORD=""" >> ~/.bashrc
  ```
  **Reload shell to set env var**
* Now run:
  ```shell
  ~/piserver/run.sh
  ```
  This will start all Docker containers and they will restart on reboot

* Modify `/etc/rc.local` by adding following line:
  ```shell
  cd /home/alp/piserver/scripts && sudo python /home/alp/piserver/scripts/server.py &
  ```

  Additional you need to copy `known_hosts`, `id_rsa` and `id_rsa.pub` to `/root/.ssh/` as service will be running as `root`.

### Updating Docker

- pull images
```
docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull
```
- restart all running
```
docker restart $(docker ps -q)
```

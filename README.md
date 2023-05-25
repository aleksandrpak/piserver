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


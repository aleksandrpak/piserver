# piserver

## Prerequisites

NOTE: Tested on Raspberry Pi OS 64-bit lite

* Configure SSH in Raspberry Pi imager
* Install Git: `sudo apt install git`
* Install Docker:
  ```shell
  curl -fsSL https://get.docker.com -o install-docker.sh
  sudo sh install-docker.sh
  sudo usermod -aG docker ${USER}
  ```
  **You need to logout and log back in after this**
* Follow instructions to install [Github CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt)
* Login with Github CLI: `gh auth login`
* Clone this repo: `gh repo clone aleksandrpak/piserver`

#!/usr/bin/env bash
# set noninteractive installation
export DEBIAN_FRONTEND=noninteractive
#install tzdata package
apt-get install -y tzdata
# set your timezone
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
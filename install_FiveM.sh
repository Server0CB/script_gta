#!/bin/bash
#
#
# https://ocb.re
# Un canal discord est dispo
#
###
# Renseignez  des login à  vous // par default gta5:gta5
login=gta5
password=gta5
###########

if ! useradd $login -d /home/$login -s /bin/false  -p {`openssl passwd -1 $password`}; then
exit 1
fi
uid=$(grep -w $login /etc/passwd | awk -F: '{ print $3 }')
gid=$(grep -w $login /etc/passwd | awk -F: '{ print $4 }')
mkdir /home/$login \
&& chown $uid:$uid /home/$login \
&& chgrp $gid /home/$login \
apt install git wget curl xz-utils
mast="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
clock="$(curl $mast | grep '<a href' | tail -1 | awk -F[\>\<] '{print $3}')"
cd /home/gta5/
wget ${mast}${clock}fx.tar.xz
tar xf fx.tar.xz
rm ./fx.tar.xz
git clone https://github.com/citizenfx/cfx-server-data.git server-data
wget https://raw.githubusercontent.com/Server0CB/script_gta/master/server.cfg
mv /home/$login/server.cfg /home/$login/server-data/server.cfg
cd ..
chmod -R 777 ./*



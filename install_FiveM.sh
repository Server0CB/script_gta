#!/bin/bash
#V0.2
#https://ocb.re rejoignez le discord !
#####
PUBLIC_IP=$(command wget -qO- 'http://ipecho.net/plain')

fullExit() {
	cat << EOF
Contact me: https://ocb.re
EOF
	exit 1
}
runUserCmd() {
	su - \$USER -c "\$USER_INIT; \$1" >/dev/null && return 0
	return 1
}
if [ "$(id -u)" != "0" ]; then
	fullExit "Tournée le script en root (Ou sudo)."
fi

## License
echo "
-----------------------------------------------------------------------------
Tout contact sur discord ! http://ocb.re
-----------------------------------------------------------------------------"
echo "Installeur FiveM"
echo
echo "y = Choix yes (continues)"
echo "n = Choix On n'annule avec cette option"
echo "c = Choix on quitte le script"
echo "Capital 'Y' or 'N' or 'C' Option par default"
echo
read -p "Voulez vous continué ? [Y/n/c] " confirm
if [[ $confirm =~ ^([cC]|[nN])$ ]]
then
    exit 0
fi
## Generate locales
locale-gen fr_FR.UTF-8
dpkg-reconfigure locales
## Prompting for system user.
con=0
while [ $con -eq 0 ]; do
	echo -n "$Enter le nom d'utilisateur : "
	read USER

	if [ -z "$USER" ]; then
		echo "Error: déjà enregistré!!"
	elif [ -z $(cat /etc/passwd | grep "^$USER:") ]; then
		read -p "la selection ($USER) n'existe pas voulez le vous le crées? [Y/n/c] " confirm
		if [[ $confirm =~ ^([nN]|[cC])$ ]]
        then
            exit 1
        else
			adduser $USER;
			con=1
			HOMEDIR=$(cat /etc/passwd | grep "$USER": | cut -d: -f6);
		fi
	elif [ $(cat /etc/passwd | grep "^$USER:" | cut -d: -f3) -lt 999 ]; then
		echo "$Error: le UID existe déjà!"
	elif [ $USER = nobody ]; then
		echo
		echo "$Error: l'user 'nobody' ne peux être selectioner"
	else
		HOMEDIR=$(cat /etc/passwd | grep "$USER": | cut -d: -f6);
		con=1
	fi
done








apt install git wget curl xz-utils screen unzip docker-compose -y
apt-get update && apt dist-upgrade -y
apt-get autoremove -y
masterfolder="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
newestfxdata="$(curl $masterfolder | grep '<a href' | tail -1 | awk -F[\>\<] '{print $3}')"
cd "/home/$USER/" || exit
wget "${masterfolder}""${newestfxdata}fx.tar.xz"
tar xf fx.tar.xz
rm ./fx.tar.xz
git clone https://github.com/citizenfx/cfx-server-data.git server-data
wget https://raw.githubusercontent.com/Server0CB/script_gta/master/server.cfg
mv "/home/$USER/server.cfg" "/home/$USER/server-data/server.cfg"
cd ..
chmod -R 777 ./*

#Install docker
#curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
#wget https://raw.githubusercontent.com/Server0CB/script_gta/master/docker-compose.yml

mkdir "/home/$USER/server-data/resources/[MySQL]"
cd   "/home/$USER/server-data/resources/[MySQL]"
wget https://github.com/brouznouf/fivem-mysql-async/archive/v2.0.2.zip
wget https://kanersps.pw/files/essential5.zip
wget https://kanersps.pw/files/esplugin_mysql.zip
git clone https://github.com/ESX-Org/async.git async
unzip v2.0.2.zip
unzip essential5.zip
unzip esplugin_mysql.zip
rm -rf v2.0.2.zip
rm -rf essential5.zip
rm -rf esplugin_mysql.zip
mv fivem-mysql-async-2.0.2/ mysql-async/


mkdir "/home/$USER/server-data/resources/[UI]"
cd  "/home/$USER/server-data/resources/[UI]"
git clone https://github.com/ESX-Org/esx_menu_default.git esx_menu_default
git clone https://github.com/ESX-Org/esx_menu_dialog.git esx_menu_dialog
git clone https://github.com/ESX-Org/esx_menu_list.git esx_menu_list


echo '-------------------------------------------------------------------------------------------------'
echo
echo "Installation terminer vous avez votre base de fiveM avec mysql phpmyadmin !" 
echo "Votre nom d'utilisateur est $USER N'oubliez pas de lancer FiveM avec cette utilisateur !"
echo
echo
echo "votre IP public est" "${PUBLIC_IP}"
echo Faut faire un su "$USER"
echo puis un cd /home/"$USER"/server-data
echo puis bash /home/"$USER"/run.sh +exec server.cfg
echo
echo
echo "Ne pas oubliez de mofidier la key, par le votre, dans votre server.cfg !!!!"
echo Le serveur.cfg se situe dans /home/"$USER"/server-data
echo
echo
echo
echo "Toute question rejoignez discord sur https://ocb.re !"
echo
echo "regardez dans le dossier /home/$USER/server-data/ressource/\\[MySQL\\]/ est rajoutez la sql ! esplugin_mysql"
echo "n'oubliez pas de rensiegnez les sql !"
echo "https://github.com/ESX-Org/es_extended/blob/master/es_extended.sql"
echo "---------------------------------------------------------------------------------------------------"

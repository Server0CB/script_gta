#!/bin/bash
#V0.5
#https://ocb.re rejoignez le discord !
#####
#####
PUBLIC_IP=$(command wget -qO- 'http://ipecho.net/plain')


#Seul root peut executer le script
if [ $UID -ne 0 ] ; then
        echo "Vous devez etre root pour executer ce script"
        exit 1
fi
## Generate locales
locale-gen fr_FR.UTF-8
dpkg-reconfigure locales

#Update de base
apt update && apt dist-upgrade -y
apt install git wget curl xz-utils screen unzip apache2 php7.0 php7.0-gd php7.0-curl php7.0-mysql php7.0-mcrypt -y
apt update
apt-get autoremove -y
#expo de l'ip de la machine
PUBLIC_IP=$(command wget -qO- 'http://ipecho.net/plain')

#Artefact FiveM
masterfolder="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
newestfxdata="$(curl $masterfolder | grep '<a href' | tail -1 | awk -F[\>\<] '{print $3}')"

echo -e "${CBLUE} On va crées un nouvelle utilisateur pour lancer notre serveur par la suite ! $CEND"
con=0
while [ $con -eq 0 ]; do
	echo -n " Enter le nom d'utilisateur :"
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
clear
echo -e " "
echo -e "/!\ On va commencer par installer la base de FiveM /!\ "
echo -e " "
echo -e "Marquer oui pour lancer le script !"
read -r PAPA
echo -e " "

if [ "PAPA" != "oui" ]; then
	echo -e "On n'y va !"
else
	exit 0
fi

#Install docker
#curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
#wget https://raw.githubusercontent.com/Server0CB/script_gta/master/docker-compose.yml
#docker-compose up -d

if [ $1 = $1]; then
	cd "/home/$USER/"
	wget "${masterfolder}""${newestfxdata}fx.tar.xz"
	tar xf fx.tar.xz && rm -rf fx.tar.xz
    git clone https://github.com/citizenfx/cfx-server-data.git server-data
    wget https://raw.githubusercontent.com/Server0CB/script_gta/master/server.cfg server.cfg
    mv "/home/$USER/server.cfg" "/home/$USER/server-data/server.cfg"
    cd .. || exit
fi
#Permission au fichier
	chown -R "$USER":"$USER" /home/"$USER"
	chown "$USER":"$USER" /home/"$USER"
	chmod 755 /home/"$USER"
echo "Base de FiveM fini"

#Ressource mysql 
mkdir "/home/$USER/server-data/resources/[MySQL]"
cd   "/home/$USER/server-data/resources/[MySQL]"
git clone https://github.com/brouznouf/fivem-mysql-async.git mysql-async
wget https://kanersps.pw/files/essential5.zip
wget https://kanersps.pw/files/esplugin_mysql.zip
git clone https://github.com/ESX-Org/async.git async
unzip essential5.zip && unzip esplugin_mysql.zip

#Ressource dans les dossier de base 
mkdir "/home/$USER/server-data/resources/[UI]"
cd  "/home/$USER/server-data/resources/[UI]"
git clone https://github.com/ESX-Org/es_extended.git es_extended
git clone https://github.com/ESX-Org/esx_menu_default.git esx_menu_default
git clone https://github.com/ESX-Org/esx_menu_dialog.git esx_menu_dialog
git clone https://github.com/ESX-Org/esx_menu_list.git esx_menu_list

clear
echo -e "/!\ Instalation de mysql-server /!\ Choisiez oui ou non ?"
read -r confir 
echo -e ""
if [ "confir" != "oui" ]; then
	echo -e "On lance l'install de mysql"
else
	exit 0
fi
echo -n " Entrez Un mot de passe pour mysql-server : " 
read password
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password PASS'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password PASS'
apt-get install -y mariadb-server
mysql -uroot -pPASS -e "SET PASSWORD = PASSWORD('');"
echo -e "\ny\ny\nabc\nabc\ny\ny\ny\ny" | /usr/bin/mysql_secure_installation


echo '-------------------------------------------------------------------------------------------------'
echo
echo "Installation terminer vous avez votre base de fiveM avec mysql !" 
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
echo "---------------------------------------------------------------------------------------------------"

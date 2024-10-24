#! /bin/bash

# Variables globales

user_active=1

date_info_log=$(date +%Y%m%d)
name_info_log="info_<Cible>_$date_info_log.txt"

name_event_log='/var/log/log_evnt.log'

#

# FUNCTIONS

# Generic function - add a line to name_event_log file
addEventLog()
{
# initialisation des variables
	date_event=$(date +%Y%m%d)
	time_event=$(date +%H%M%S)
	user_event=$USER
	label_event=$1				# premier argument de la FONCTION (et non du script)

# construction du message à logguer sur le modèle '<Date>-<Heure>-<Utilisateur>-<Evenement>'
	message="$date_event-$time_event-$user_event-$label_event"

# écriture en fin de fichier log
	echo $message >> $name_event_log
}

# Init (or touch) name_event_log file - reset chmod 666 and owner - to avoid sudo
checkEventLog()
{
	sudo touch $name_event_log
	sudo chmod 666 $name_event_log
	sudo chown $USER:$USER $name_event_log
	echo "** Touch $name_event_log **" >> $name_event_log
# cat /var/log/log_evnt.log
}

# Target network testing function
sshTest()
{
	ping -c 2 $targetIp > /dev/null

	if [[ $? == 0 ]]; then
			ssh -T $targetUsername@$targetIp "echo "
			if [[ $? != 0 ]]; then
				echo "La cible n'a pas configuré son SSH."
				addEventLog '** Echec de connexion - EndScript **'
				exit 1
			fi
	else
			echo "La cible n'est pas démarrée, ou n'est pas connectée au réseau."
			addEventLog '** Echec de connexion - EndScript **'
			exit 1
	fi

	addEventLog "Test OK de la connexion SSH"
}

addUser()
{
	read -p "Nom de l'utilisateur à créer " user_target
	# cnx ssh
	ssh -T $targetUsername@$targetIp <<eof
	sudo useradd -m -s /bin/bash -p $user_target $user_target >> ./$name_info_log
	if [[ $? == 0 ]]; then
		echo "Création de l'utilisateur « $user_target »" >> ./$name_info_log
	fi
eof
	# le script ssh teste la valeur de sortie, car en cas de succès, useradd ne renvoie rien
	scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log

	addEventLog "Création de l'utilisateur $user_target"
	echo commande réalisée
	echo ''
}

supprUser()
{
	read -p "Nom de l'utilisateur à supprimer " user_delete
# cnx ssh
	ssh -T $targetUsername@$targetIp <<eof
	sudo deluser --remove-home $user_delete >> ./$name_info_log
eof
	scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log
	addEventLog "Suppression de l'utilisateur $user_delete"
	echo commande réalisée
	echo ''
}

listUsers()
{
# ne liste que les utilisateurs ayant un dossier créé dans /home/
# cnx ssh
	ssh -T $targetUsername@$targetIp <<eof
	grep /home/.*/ /etc/passwd
	grep /home/.*/ /etc/passwd  >> ./$name_info_log
eof
	scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log
	addEventLog "Listage des utilisateurs"
	echo commande réalisée
	echo ''
}


switchOffTarget()
{
	read -p "Êtes-vous sûr de vouloir éteindre ? (O/n)" confirm1
	if [ "O" = $confirm1 ] || [ -z $confirm1 ]
	then
		echo "Reboot scheduled" >> ./$name_info_log
		scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log
		ssh -T $targetUsername@$targetIp <<eof
		sudo shutdown -H 1
eof

		addEventLog "Eteinte dans 1 mn de la machine cible"
		echo commande réalisée
		echo ''
	fi
}


restartTarget()
{
	read -p "Êtes-vous sûr de vouloir redémarrer ? (O/n)" confirm2
	if [ "O" = $confirm2 ] || [ -z $confirm2 ]
	then
		echo "Restart scheduled" >> ./$name_info_log
		scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log
		ssh -T $targetUsername@$targetIp <<eof
		sudo shutdown -r 1
eof

		addEventLog "Redémarrage dans 1 mn de la machine cible"
		echo commande réalisée
		echo ''
	fi
}
#

# MAIN START

checkEventLog

addEventLog '********StartScript********'

# Asking user to input target IP address & target username
read -p "Quelle est l'adresse IP de la cible : " targetIp
read -p "Quel est le nom de l'utilisateur cible : " targetUsername

# Build target log name with target username
# example : $targetUsername='wilder' ; <Cible> in string is replaced by wilder
name_info_log=$(echo $name_info_log | sed "s/<Cible>/$targetUsername/")



# MAIN LOOP

while [ $user_active -eq 1 ]
  do
	sshTest

echo "
	1) Ajouter un utilisateur
	2) Supprimer un utilisateur
	3) Lister les utilisateurs
	4) Eteindre la machine
	5) Redémarrer la machine
	X) Quitter le programme"

	addEventLog "Prompt Attente commande"
	read -p "Votre choix: " cmdChoice

  case $cmdChoice in
	1) addUser
		;;
	2) supprUser
		;;
	3) listUsers
		;;
	4) switchOffTarget
		;;
	5) restartTarget
		;;
	X|x) user_active=0
		;;
  esac

done # fin boucle principale

addEventLog '********EndScript********'
echo -e "Fin de session\n"

# END OF MAIN

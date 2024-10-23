#! /bin/bash

# Variables globales

user_actif=1

date_info_log=$(date +%Y%m%d)
name_info_log="info_<Cible>_$date_info_log.txt"

name_event_log='/var/log/log_evnt.log'

#

# FUNCTIONS


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

# Target network testing function
sshTest()
{
	ping -c 2 $targetIp > /dev/null

	if [[ $? == 0 ]]; then
			ssh -T $targetUsername@$targetIp "echo "
			if [[ $? != 0 ]]; then
				echo "La cible n'a pas configuré son SSH."
			exit 1
			fi
	else
			echo "La cible n'est pas démarrée, ou n'est pas connectée au réseau."
			exit 1
	fi

	addEventLog "Test OK de la connexion SSH"
}

addUser()
{
	read -p "Nom de l'utilisateur à créer " user_target
	# cnx ssh
	ssh -T $targetUsername@$targetIp <<eof
	sudo useradd -m -s /bin/bash -p $user_target $user_target
# On écrit directement sur le log car useradd ne renvoie aucun message en cas de succès
	echo "Création de l'utilisateur « $user_target" » >> ./$name_info_log
eof
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


switchOffTarget()
{
	read -p "Êtes-vous sûr de vouloir éteindre ? (O/n)" confirm1
	if [ "O" = $confirm1 ] || [ -z $confirm1 ]
	then
		ssh -T $targetUsername@$targetIp <<eof
		sudo shutdown -H 1 >> ./$name_info_log
eof
		scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log
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
		ssh -T $targetUsername@$targetIp <<eof
		sudo shutdown -r 1 >> ./$name_info_log
eof
		scp -q $targetUsername@$targetIp:/home/$targetUsername/$name_info_log ./Documents/$name_info_log
		addEventLog "Redémarrage dans 1 mn de la machine cible"
		echo commande réalisée
		echo ''
	fi
}
#

# MAIN START

addEventLog '********StartScript********'

# Asking user to input target IP address & target username
read -p "Quelle est l'adresse IP de la cible : " targetIp
read -p "Quel est le nom de l'utilisateur cible : " targetUsername

# Build target log name with target username
name_info_log=$(echo $name_info_log | sed "s/<Cible>/$targetUsername/")
# exemple : info_<Cible>_20241018.txt  devient  info_wilder_20241018.txt


# MAIN LOOP

while [ $user_actif == 1 ]

  sshTest

  do
echo "
	1) Ajouter un utilisateur
	2) Supprimer un utilisateur
	3) Redémarrer la machine
	4) Eteindre la machine
	X) Quitter le programme"

  addEventLog "Prompt Attente commande"
  read -p "Votre choix: " cmdChoice

  case $cmdChoice in
	1) addUser
		;;
	2) supprUser
		;;
	3) switchOffTarget
		;;
	4) restartTarget
		;;
	X|x) user_actif=0
		;;
  esac

done # fin boucle principale

addEventLog '********EndScript********'
echo -e "Fin de session\n"

# END OF MAIN

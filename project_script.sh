#! /bin/bash

# Variables

user_actif=1
date_info_log=$(date +%Y%m%d)
name_info_log="info_<Cible>_$date_info_log.txt"

#name_info_log=$(date +% "info_<Cible>_%Y%m%d.txt")


# exemple de résultat : génère name_info_log="info_<Cible>_20241018.txt"
#

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
}

#
# FUNCTIONS

addUser()
{
	read -p "Nom de l'utilisateur à créer " user_target
	# cnx ssh
	ssh -T $targetUsername@$targetIp <<eof
	sudo useradd -m -s /bin/bash -p $user_target $user_target >> ./$name_info_log
eof
	scp $targetUsername@$targetIp:/home/$user_target/$name_info_log ~/Documents/

	echo commande réalisée
	echo retour au menu

}

supprUser()
{
	read -p "Nom de l'utilisateur à supprimer " user_delete
# cnx ssh
	ssh -T $targetUsername@$targetIp <<eof
	sudo deluser --remove-home $user_delete >> ./$name_info_log
eof
	scp $targetUsername@$targetIp:/home/$user_target/$name_info_log ~/Documents/

	echo commande réalisée
	echo retour au menu

}

switchOffTarget()
{
	read -p "Êtes-vous sûr de vouloir éteindre ? (O/n)" confirm1
	if [ "O" = $confirm1 ] || [ -z $confirm1 ]
	then
		ssh -T $targetUsername@$targetIp <<eof
		shutdown -H now
eof
	fi
}

restartTarget()
{
	read -p "Êtes-vous sûr de vouloir redémarrer ? (O/n)" confirm2
	if [ "O" = $confirm2 ] || [ -z $confirm2 ]
	then
		ssh -T $targetUsername@$targetIp <<eof
		shutdown -r now
eof
	fi
}
#

# MAIN START

# Asking user to input target IP address & target username
read -p "Quelle est l'adresse IP de la cible : " targetIp
read -p "Quel est le nom de l'utilisateur cible : " targetUsername

name_info_log=$(echo $name_info_log | sed "s/<Cible>/$targetUsername/")
# exemple : info_<Cible>_20241018.txt  devient  info_user_20241018.txt



while [ user_actif == 1 ]

  sshTest

  do
echo "	1) Ajouter un utilisateur
	2) Supprimer un utilisateur
	3) Redémarrer la machine
	4) Eteindre la machine
	X) Quitter le programme"

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

# END OF MAIN

echo -e "Fin de session\n"

# FUNCTIONS about LOG

# addTargetLog()
#{

#}

#addEventLog()
#{

#}

#


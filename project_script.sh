#! /bin/bash

# Target network testing function
sshTest()
{
	ping -c 2 $targetIp >> /dev/null
		if [[ $? == 0 ]]; then
			ssh -T $targetUsername@$targetIp "exit"
				if [[ $? != 0 ]]; then
					echo "La cible n'a pas configuré son SSH."
					exit 1
				fi
		else
			echo "La cible n'est pas démarrée, ou n'est pas connectée au réseau."
			exit 1			
		fi
}


# MAIN START

# Asking user to input target IP address & target username
read -p "Quelle est l'adresse IP de la cible?" targetIp
read -p "Quel est le nom de l'utilisateur cible?" targetUsername

sshTest

echo "	1) Ajouter un utilisateur
	2) Supprimer un utilisateur
	3) Redémarrer la machine
	4) Eteindre la machine
	X) Quitter le programme"
read -p "Votre choix: " cmdChoice

case $cmdChoice in
	1 ) #TODO insérer fonction ajout utilisateur
		;;
	2 ) #TODO insérer fonction suppression utilisateur
		;;
	3 ) #TODO insérer fonction éteindre
		;;
	4 ) #TODO insérer fonction redémarrage
		;;
	X ) exit
		;;
esac
# END OF MAIN
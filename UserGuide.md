### Introduction 

Welcome to project Copper statistically average user.
This script is designed to allow you to connect remotely to a Linux machine using a Linux server (In our case Ubuntu and Debian respectively) and perform a wide variety of actions.
We will guide you step by step on the way to success, wealth and eternal youth!

### Getting started

- Before doing anything make sure you have the IP address of the remote computer as well as the user name of the session you will use on the remote computer.
- Make sure the remote computer is turned on.
- Connect to your server using a session with execution rights over project Copper.


### Usage walkthrough


1. In your CLI type the following command to execute the script: "./project_script.sh"
   
2. The script will prompt you to enter the IP address of the remote then prompt you to enter the name of the user session on said target. (if the IP address is incorrect the script will stop and give the following error "La cible n'a pas configuré son SSH."; if the target computer is not connected to the network this error will appear: "La cible n'est pas démarrée, ou n'est pas connectée au réseau.").
   
3. Once the connection server-to-client is established a menu appears on your console giving you the following choices:
				         1.Ajouter un utilisateur
				         2.Supprimer un utilisateur
				         3.Lister les utilisateurs
						 4.Redémarrer la machine
						 5.Eteindre la machine
						 X.Quitter le programme

#### The commands

1. "Ajouter un utilisateur" prompts you with "Nom de l'utilisateur à créer" Enter the username you want to create, the default password for the session you create is the username. This creates a new user with the /home/$user attached
   
2. "Supprimer un utilisateur" prompts you with "Nom de l'utilisateur à supprimer". Enter the username you would like to delete. This will delete the user on the remote machine as well as the /home/$user of that user.
   
3. "Lister les utilisateurs" gives the list of existing users with a /home/$user on the remote machine. This command allows you to verify if your add/rm users did indeed work.
   
4. "Redémarrer la machine" prompts you with "Êtes-vous sûr de vouloir redémarrer ? (O/n)" confirm with "O" (uppercase). "Redémarrage dans 1 mn de la machine cible" will appear and the remote computer will restart a minute later. You will have to connect again to do anything else on the remote machine.
   
5. "Eteindre la machine" prompts you with "Êtes-vous sûr de vouloir éteindre ? (O/n)" confirm by entering "O" (uppercase). "Eteinte dans 1 mn de la machine cible" will appear and the remote machine will shut down a minute later. You will have to turn the machine back on manually to connect again.
   
6. or "X" will simply leave the script

After each action finishes the script goes back to the main menu and wait for you to give further input or leave by entering X

#### Logs

Our script generates two different logs. 
The first one is global and includes script's starts and stops and commands entered in the server's console. It is locate there on the server
```
/var/log
```
The second one only contains the commands and results of said commands on the remote machine.
It is located there on the server
```
/home/$user/documents
```


Congratulation you now have complete control over the remote machine. You're now worthy of the title of ![[Hackerman.jpg]]


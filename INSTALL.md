# INSTALL GUIDE

### Required Elements 💻

- Operational Linux hosts (we made this program using a VirtualBox infrastructure including 1 debian 12 and 1 Ubuntu 24.04) in **the same sub-net**.

- A working **SSH system** between hosts. For help installing, check the SSH configuration below.

### /!\ OPTIONAL /!\ Installing Virtual Machines using VirtualBox 💿

- Debian 12 (the "server")
    - Download [Debian iso](www.debian.org)
    - Create a new VM 

        ![new VM](https://neptunet.fr/wp-content/uploads/2020/06/vbox01-2.png)

    - Name your VM as you wish, and choose path to your ISO file. VirtualBox will recognize the Debian distribution and will change the other parameters.(in the screenshot, this is a Windows10 VM)

        ![VM config](https://neptunet.fr/wp-content/uploads/2020/06/vbox03.png)

    - Then, you have to allocate RAM and CPU cores, we recommend **4Gb RAM and 2 cores**

        ![RAM](https://neptunet.fr/wp-content/uploads/2020/06/vbox04.png)

    - Next step is creating a virtual hard disk. Create at least a **25Gb drive**.

        ![drive](https://neptunet.fr/wp-content/uploads/2020/06/vbox05.png)

    - Start your VM to install OS

- Repeat the steps with Ubuntu (Download [here](www.ubuntu.com))

- Setting Subnet configuration:
    - In Virtualbox, go to Files > Tools > NetworkManager and create **a new NAT Network**

        ![Nat](https://storage.googleapis.com/quest_editor_uploads/lej3BoBrAGdjHUYsdk5UuuhXyfnZ4iMI.png)
        
    - In each VM, in settings, set interface as **NAT Network**:

        ![Natvm](https://storage.googleapis.com/quest_editor_uploads/4wmuvgnb6GgLEloUL7NiwaG6cwlku2T2.png)

- Setting Static IP address
    - For each VMs, in your terminal:
        ````sudo ip addr add 10.0.0.10/24 dev eth1````

        **Change values to match with your situation**

### Installing SSH and configuration ⌨️

**The computer starting the SSH connection will be called "local computer" in the section below. In the same way, the computer receiving the connection will be called "remote computer".**

- Install _SSH-server_ on the **remote computer**.
In the CLI, type:

    ````sudo apt install openssh-server````

    After command completion, reboot the computer.

- On the **local computer**:
    - Check if SSH logon is operating. In the CLI:

        ````ssh remotecomputerusername@remotecomputeripaddress````

        A password prompt will be shown if SSH is working.

    - Create a SSH public key:

        ````ssh-keygen -t rsa````

        Press **ENTER** each prompt to select default values. (_You can add a passphrase if you want_)
    - Send the public key on the remote computer:

        ````ssh-copy-id remotecomputerusername@remotecomputeripaddress````

        You can now connect without typing remote password

        ````ssh remotecomputerusername@remotecomputeripaddress````

🎉🎉 **WELL DONE! YOU CAN NOW LOG ON YOUR DISTANT COMPUTER REMOTELY!!** 🎉🎉

### Installing this amazing script 🥸

- **On the remote computer**, disable password for sudo commands. Using terminal

    ````sudo nano /etc/sudoers````

    Change the line to:

    ````myuser ALL=(ALL) NOPASSWD: ALL````
for a single user

    ````%sudo  ALL=(ALL) NOPASSWD: ALL````
for all sudoers group

- Copy the script file where you want **on the "local computer"**

- Change permission to launch the script using terminal:
````chmod +x project_script.sh````

- Launch script by typing in terminal:
````./project_script.sh````




### Final Step: ENJOY 🤖
# INSTALL GUIDE

### Required Elements

* Operationnal Linux hosts (we made this program using a VirtualBox infrastructure including 1 debian 12 and 1 Ubuntu 24.04) in **the same sub-net**.
If you want to run this script on Virtual Machines, [here is a tutorial for VirtualBox use](https://www.virtualbox.org/manual/ch01.html#create-vm-wizard) .
* A working **SSH system** between hosts. For help installing, check the SSH configuration below.

### Installing SSH and configuration

**The computer starting the SSH connection will be called "local computer" in the section below. In the same way, the computer receiving the connection will be called "remote computer".**

* Install _SSH-server_ on the **remote computer**.
In the CLI, type:

    ````sudo apt install openssh-server````

    After command completion, reboot the computer.

* On the **local computer**:
    * Check if SSH logon is operating. In the CLI:
````ssh remotecomputerusername@remotecomputeripaddress````
    A password prompt will be shown if SSH is working.
    * Create a SSH public key:
````ssh-keygen -t rsa````
    Press **ENTER** each prompt to select default values. (_You can add a passphrase if you want_)
    * Send the public key on the remote computer:
````ssh-copy-id remotecomputerusername@remotecomputeripaddress````
    You can now connect without typing remote password
    ````ssh remotecomputerusername@remotecomputeripaddress````

**WELL DONE! YOU CAN NOW LOGIN ON YOUR DISTANT COMPUTER REMOTELY!!**


# linux-fresh-install
Useful apps for myself that are auto installed in a bash script. Will be updated in the future. 

Current list:

1.Discord

2.TLDR

3.Sensors

4.NMap

5.Wireshark

6.Steam

7.Discord

This simple script is used to get new installs of linux up to my standards ASAP. It automatically installs these applications, either via the package manager
or by directly pulling from the website and auto installing it from there. 

This script also tells you whether the application successfully installed or not, and cleans up the trash files left behind from the install.

A log file is created and contains info from the installation process of each application. Useful for debugging purposes.

Finally, this script changes some settings that I prefer, such as RFkilling wifi and bluetooth, and shutting down their respective interfaces.
It also ensures the firewall is turned on in case I forget. 

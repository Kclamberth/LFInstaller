#!/bin/bash

#Application list
app1=htop
app2=tldr
app3=lynis
app4=nmap
app5=wireshark
app6=steam
app7=discord
app8=fail2ban
app9=vim
app10=flatpak
app11=iftop

#Welcome message
echo "Welcome to KCL App installer!"
echo " "
sudo apt-get update >> kcl_pack_installer.log

#App install
echo "Installing applications... "

sudo apt-get install -y $app1 >> kcl_pack_installer.log
e1=$?
sudo apt-get install -y $app2 >> kcl_pack_installer.log
e2=$?
sudo apt-get install -y $app3 >> kcl_pack_installer.log
e3=$?
sudo apt-get install -y $app4 >> kcl_pack_installer.log
e4=$?
sudo apt-get install -y $app5 >> kcl_pack_installer.log
e5=$?
sudo apt-get install -y $app6 >> kcl_pack_installer.log
e6=$?
sudo apt-get install -y $app8 >> kcl_pack_installer.log
e8=$?
sudo apt-get install -y $app9 >> kcl_pack_installer.log
e9=$?
sudo apt-get install -y $app10 >> kcl_pack_installer.log
e10=$?
sudo apt-get install -y $app11 >> kcl_pack_installer.log
e11=$?

wget -q "https://discord.com/api/download?platform=linux&format=deb" >> kcl_pack_installer.log
sudo chmod +x 'download?platform=linux&format=deb' >> kcl_pack_installer.log
sudo dpkg -i ~/'download?platform=linux&format=deb' >> kcl_pack_installer.log
e7=$?

#flatpak applications
if [ $e10 -eq 0 ]
then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> kcl_pack_installer.log
    sleep 3
    flatpak install -y flathub com.ultimaker.cura >> kcl_pack_installer.log
    ea=$?
fi

#exit codes & messages
if [ $e1 -eq 0 ]
then
    echo "$app1 successfully installed."
else
    echo "$app1 FAILED to install."
fi

if [ $e2 -eq 0 ]
then
    echo "$app2 successfully installed."
else
    echo "$app2 FAILED to install."
fi

if [ $e3 -eq 0 ]
then
    echo "$app3 successfully installed."
else
    echo "$app3 FAILED to install."
fi

if [ $e4 -eq 0 ]
then
    echo "$app4 successfully installed."
else
    echo "$app4 FAILED to install."
fi

if [ $e5 -eq 0 ]
then
    echo "$app5 successfully installed."
else
    echo "$app5 FAILED to install."
fi

if [ $e6 -eq 0 ]
then
    echo "$app6 successfully installed."
else
    echo "$app6 FAILED to install."
fi

if [ $e7 -eq 0 ]
then
    echo "$app7 successfully installed."
else
    echo "$app7 FAILED to install."
fi

if [ $e8 -eq 0 ]
then
    echo "$app8 successfully installed."
else
    echo "$app8 FAILED to install."
fi

if [ $e9 -eq 0 ]
then
    echo "$app9 successfully installed."
else
    echo "$app9 FAILED to install."
fi

if [ $e10 -eq 0 ]
then
    echo "$app10 successfully installed."
else
    echo "$app10 FAILED to install."
fi

if [ $e11 -eq 0 ]
then
    echo "$app11 successfully installed."
else
    echo "$app11 FAILED to install."
fi

if [ $ea -eq 0 ]
then
    echo "Ultimaker Cura successfully installed."
else
    echo "Ultimaker Cura FAILED to install."
fi

echo " "
sleep 3

#Trash cleanup
echo "Removing trash files..."
currentdirectory=$(pwd)
rm $currentdirectory/'download?platform=linux&format=deb'

echo " "
sleep 3

#Wireless signal cleanups
echo "RFKill blocking wifi & bluetooth, turning wifi interface off."
rfkill block wifi
rfkill block bluetooth
sudo ifconfig wlo1 down

echo "Finished installing applications and changing wireless signals."

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
sudo apt-get update >> kcl_pack_installer.log 2>&1

#App install
echo "Installing applications... (1/12)"
sudo apt-get install -y -q $app1 >> kcl_pack_installer.log 2>&1 #appends stderror AND stdout to log
e1=$?
echo "Installing applications... (2/12)"
sudo apt-get install -y -q $app2 >> kcl_pack_installer.log 2>&1
e2=$?
echo "Installing applications... (3/12)"
sudo apt-get install -y -q $app3 >> kcl_pack_installer.log 2>&1
e3=$?
echo "Installing applications... (4/12)"
sudo apt-get install -y -q $app4 >> kcl_pack_installer.log 2>&1
e4=$?
echo "Installing applications... (5/12)"
sudo apt-get install -y -q $app5 >> kcl_pack_installer.log 2>&1
e5=$?
echo "Installing applications... (6/12)"
sudo apt-get install -y -q $app6 >> kcl_pack_installer.log 2>&1
e6=$?
echo "Installing applications... (7/12)"
sudo apt-get install -y -q $app8 >> kcl_pack_installer.log 2>&1
e8=$?
echo "Installing applications... (8/12)"
sudo apt-get install -y -q $app9 >> kcl_pack_installer.log 2>&1
e9=$?
echo "Installing applications... (9/12)"
sudo apt-get install -y -q $app10 >> kcl_pack_installer.log 2>&1
e10=$?
echo "Installing applications... (10/12)"
sudo apt-get install -y -q $app11 >> kcl_pack_installer.log 2>&1
e11=$?


#pull from discord site
echo "Installing applications... (11/12)"
wget -q "https://discord.com/api/download?platform=linux&format=deb" >> kcl_pack_installer.log 2>&1
sudo chmod +x 'download?platform=linux&format=deb' >> kcl_pack_installer.log 2>&1
sudo dpkg -i ~/'download?platform=linux&format=deb' >> kcl_pack_installer.log 2>&1
echo "Fixing dependencies... (11/12)"
sudo apt-get install -f -y >> kcl_pack_installer.log  2>&1 #fix dependencies 
e7=$?

#flatpak applications
if [ $e10 -eq 0 ] #only execute if flatpak successfully installs
then
    echo "Installing applications... (12/12)"
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> kcl_pack_installer.log 2>&1
    sleep 3
    sudo flatpak install -y flathub com.ultimaker.cura >> kcl_pack_installer.log 2>&1
    ea=$?
    if [ $e6 -ne 0 ] #install steam via flatpak if not available in package manager
        then
        sudo flatpak install -y flathub com.valvesoftware.Steam >> kcl_pack_installer.log 2>&1
        eb=$?
    fi
    echo "Installing applications... (DONE)"
    echo " "
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

if [ $e6 -eq 0 ] || [ $eb -eq 0 ] #steam via apt or flatpak
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

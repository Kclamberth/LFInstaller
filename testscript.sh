#!/bin/bash

app1=htop
app2=tldr
#app3=sensors
app4=nmap
app5=wireshark
app6=steam
app7=discord

echo "Welcome to KCL App installer!"
echo " "
sudo apt-get update >> kcl_pack_installer.log

echo "Installing applications... "

sudo apt-get install -y $app1 >> kcl_pack_installer.log
e1=$?
sudo apt-get install -y $app2 >> kcl_pack_installer.log
e2=$?
#sudo apt-get install -y $app3 >> kcl_pack_installer.log
#e3=$?
sudo apt-get install -y $app4 >> kcl_pack_installer.log
e4=$?
sudo apt-get install -y $app5 >> kcl_pack_installer.log
e5=$?
sudo apt-get install -y $app6 >> kcl_pack_installer.log
e6=$?
wget -q "https://discord.com/api/download?platform=linux&format=deb" >> kcl_pack_installer.log
sudo chmod +x 'download?platform=linux&format=deb' >> kcl_pack_installer.log
sudo dpkg -i ~/'download?platform=linux&format=deb' >> kcl_pack_installer.log
e7=$?

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

#if [ $e3 -eq 0 ]
#then
#    echo "$app3 successfully installed."
#else
#    echo "$app3 FAILED to install."
#fi

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

echo " "

sleep 3

echo "Removing trash files..."
currentdirectory=$(pwd)
rm $currentdirectory/'download?platform=linux&format=deb'

sleep 3

echo " "

sleep 3

echo "RFKill blocking wifi & bluetooth, turning wifi interface off."
rfkill block wifi
rfkill block bluetooth
sudo ifconfig wlo1 down

sleep 3
echo " "

echo "Turning firewall on."
sudo ufw enable
sudo ufw status
sleep 3

#!/bin/bash

#cd $(find ~ -name mainScript.sh 2>/dev/null | xargs dirname 2>/dev/null)
cd "$(dirname "$0")"
#Application list is applist.txt / flatpak apps are flatpaklist.txt
wget "https://raw.githubusercontent.com/Kclamberth/LFInstaller/main/linuxFreshInstall/applist.txt"
wget "https://raw.githubusercontent.com/Kclamberth/LFInstaller/main/linuxFreshInstall/flatpaklist.txt"

echo0=$( cat applist.txt | wc -l )
d0=$( cat flatpaklist.txt | wc -l )
apptotal=$(expr $echo0 + $(cat flatpaklist.txt | wc -l ) + 4)

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo permissions."
fi
#Welcome message
echo " "
echo "Welcome to KCL App installer!"
echo " "
sudo apt-get update >> /var/log/kcl_apps.log 2>&1 #updates system

declare -a e #array echo for apps
declare -a d #array delta for flatpak

#apt applications
for (( line=1; line<=$echo0; line++))
do
    echo -ne "\rInstalling applications... ($line/$apptotal)"
    app=$(cat applist.txt | awk -F "=" '{print $2}' | sed -n "$line"p)
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $app >> /var/log/kcl_apps.log 2>&1 #appends stderror AND stdout to log
    e[$line]=$?
done

#vim basic ide config
cp install_files/vimrc.txt ~/.vimrc

#tmux & plugins 
git clone "https://github.com/tmux-plugins/tpm" ~/.tmux/plugins/tpm >> /var/log/kcl_apps.log 2>&1
mv install_files/tmux.txt ~/.tmux.conf

#flatpak applications
if [ ${e[1]} -eq 0 ] #only execute if flatpak successfully installs
then
    echo -ne "\rInstalling applications... ($(expr $echo0 + 1)/$apptotal)"
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> /var/log/kcl_apps.log 2>&1

    for ((line=1; line<=$d0; line++))
    do
	echo "Installing applications... ($( expr $echo0 + $line + 1 )/$apptotal)"
 	flatpak=$(cat flatpaklist.txt | sed -n "$line"p)
        sudo flatpak install -y flathub $flatpak >> /var/log/kcl_apps.log 2>&1
        d[$line]=$?
    done
fi
#pull from gradle website
echo -ne "\rInstalling applications... ($(expr $apptotal - 2)/$apptotal)"
mkdir /opt/gradle
wget "https://services.gradle.org/distributions/gradle-8.3-bin.zip" >> /var/log/kcl_apps.log 2>&1
unzip -d /opt/gradle gradle-8.3-bin.zip >> /var/log/kcl_apps.log 2>&1
sleep 5
if ! grep -q "/opt/gradle/gradle-8.3/bin" ~/.bashrc; then
  echo 'export PATH=$PATH:/opt/gradle/gradle-8.3/bin' >> ~/.bashrc
fi
source ~/.bashrc
ed3=$?

#pull from discord site
echo -ne "\rInstalling applications... ($(expr $apptotal - 1)/$apptotal)"
wget "https://discord.com/api/download?platform=linux&format=deb" >> /var/log/kcl_apps.log 2>&1
sudo chmod +x ~/'download?platform=linux&format=deb' >> /var/log/kcl_apps.log 2>&1
sudo dpkg -i ~/'download?platform=linux&format=deb' >> /var/log/kcl_apps.log 2>&1

#pull from yt-dlp github page
echo -ne "\rInstalling applications... ($apptotal/$apptotal)"
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp >> /var/log/kcl_apps.log 2>&1
sudo chmod a+rx /usr/local/bin/yt-dlp >> /var/log/kcl_apps.log 2>&1
sudo yt-dlp -U >> /var/log/kcl_apps.log 2>&1
ed1=$?

echo "Installing applications... (DONE)"

echo " "

#fix dependencies
echo "Fixing dependencies..."
sudo apt-get install -f -y >> /var/log/kcl_apps.log  2>&1
ed2=$? #required for discord to be successful
echo "Fixing dependencies... (DONE)"

echo " "

#exit codes & messages

#apt error codes
for((line=1; line<=$echo0; line++))
do
    if [ ${e[$line]} -eq 0 ]
    then
        echo "$(cat applist.txt | sed -n "$line"p | awk -F "=" '{print $2}') successfully installed."
    else
        echo "$(cat applist.txt | sed -n "$line"p | awk -F "=" '{print $2}') FAILED to install."
    fi
done

#flatpak error codes
for((line=1; line<=$d0; line++))
do
    if [ ${d[$line]} -eq 0 ]
    then
    	flatpakname=$(cat flatpaklist.txt | sed -n "$line"p)
        echo "flatpak $flatpakname successfully installed."
    else
        echo "flatpak $flatpakname FAILED to install."
    fi
done

#direct pull error codes
if [ $ed1 -eq 0 ]
then
    echo "yt-dlp successfully installed."
else
    echo "yt-dlp FAILED to install."
fi

if [ $ed2 -eq 0 ]
then
    echo "discord successfully installed."
else
    echo "discord FAILED to install."
fi

if [ $ed3 -eq 0 ]
then
    echo "gradle successfully installed."
else
    echo "gradle FAILED to install."
fi

echo " "

#Trash cleanup
echo "Removing trash files..."
rm "*download?platform=linux&format=deb*" 2>/dev/null
rm "*gradle-8.3-bin.zip*" 2>/dev/null
echo "Removing trash files... (DONE)"

echo " "

echo "Finished installing apt & flatpack applications."

echo " "
read -p "Would you like to install neovim as well?(y,n): " user_input

wget "https://github.com/Kclamberth/LFInstaller/blob/main/linuxFreshInstall/install_files/nviminstall.sh"
chmod +x nviminstall.sh

if [[ $user_input == "y" ]] || [[ $user_input =="Y" ]]; then
    echo "Stand by for neovim installation..."
    sleep 2
    install_files/./nviminstall.sh
else
    echo "Goodbye."
fi







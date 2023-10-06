#!/bin/bash

cd $(find / -name testscript.sh 2>/dev/null | xargs dirname 2>/dev/null)

#Application list is applist.txt / flatpak apps are flatpaklist.txt
wget "https://raw.githubusercontent.com/Kclamberth/linux-fresh-install/main/applist.txt" >> /var/log/kcl_apps.log 2>&1
wget "https://raw.githubusercontent.com/Kclamberth/linux-fresh-install/main/flatpaklist.txt" >> /var/log/kcl_apps.log 2>&1

echo0=$( cat applist.txt | wc -l )
d0=$( cat flatpaklist.txt | wc -l )
apptotal=$(expr $echo0 + $(cat flatpaklist.txt | wc -l ) + 4)

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
    echo "Installing applications... ($line/$apptotal)"
    app=$(cat applist.txt | awk -F "=" '{print $2}' | sed -n "$line"p)
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $app >> /var/log/kcl_apps.log 2>&1 #appends stderror AND stdout to log
    e[$line]=$?
done

#flatpak applications
if [ ${e[1]} -eq 0 ] #only execute if flatpak successfully installs
then
    echo "Installing applications... ($(expr $echo0 + 1)/$apptotal)"
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
echo "Installing applications... ($(expr $apptotal - 2)/$apptotal)"
mkdir /opt/gradle
wget "https://services.gradle.org/distributions/gradle-8.3-bin.zip" >> /var/log/kcl_apps.log 2>&1
unzip -d /opt/gradle gradle-8.3-bin.zip >> /var/log/kcl_apps.log 2>&1
sleep 5
export PATH=$PATH:/opt/gradle/gradle-8.3/bin
ed3=$?

#pull from discord site
echo "Installing applications... ($(expr $apptotal - 1)/$apptotal)"
wget "https://discord.com/api/download?platform=linux&format=deb" >> /var/log/kcl_apps.log 2>&1
sudo dpkg -i ~/'download?platform=linux&format=deb' >> /var/log/kcl_apps.log 2>&1

#pull from yt-dlp github page
echo "Installing applications... ($apptotal/$apptotal)"
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp >> /var/log/kcl_apps.log 2>&1
sudo chmod a+rx /usr/local/bin/yt-dlp >> /var/log/kcl_apps.log 2>&1
sudo yt-dlp -U >> /var/log/kcl_apps.log 2>&1
ed1=$?

echo "Installing applications... (DONE)"
sleep 3
echo " "

#fix dependencies
echo "Fixing dependencies..."
sudo apt-get install -f -y >> /var/log/kcl_apps.log  2>&1
ed2=$? #required for discord to be successful
echo "Fixing dependencies... (DONE)"
sleep 3
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

sleep 3
echo " "

#Trash cleanup
echo "Removing trash files..."
rm $(find / -name "download?platform=linux&format=deb" 2>/dev/null)
rm applist.txt
rm flatpaklist.txt
rm $(find / -name "gradle-8.3-bin.zip" 2>/dev/null)
echo "Removing trash files... (DONE)"

sleep 3
echo " "

echo "Finished installing applications."


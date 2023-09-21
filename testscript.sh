#!/bin/bash

#Application list is applist.txt / flatpak apps are flatpaklist.txt
wget "https://raw.githubusercontent.com/Kclamberth/linux-fresh-install/main/applist.txt" >> /var/log/kcl_apps.log 2>&1
wget "https://raw.githubusercontent.com/Kclamberth/linux-fresh-install/main/flatpaklist.txt" >> /var/log/kcl_apps.log 2>&1

echo0=$( cat $(find / -name applist.txt 2>/dev/null) | wc -l )
apptotal=$(expr $e0 + $(cat $(find / -name flatpaklist.txt 2>/dev/null) | wc -l ) + 2)

#Welcome message
echo "Welcome to KCL App installer!"
echo " "
sudo apt-get update >> /var/log/kcl_apps.log 2>&1 #updates system

declare -a e #array echo for apps

#apt applications
for (( line=1; line<=$echo0; line++))
do
    echo "Installing applications... ($line/$apptotal)"
    app=$(cat $(find / -name applist.txt 2>/dev/null) | awk -F "=" '{print $2}' | sed -n "$line"p)
    sudo apt-get install -y -q $app >> /var/log/kcl_apps.log 2>&1 #appends stderror AND stdout to log
    e[$line]=$?
done

#flatpak applications
if [ ${e[1]} -eq 0 ] #only execute if flatpak successfully installs
then
    echo "Installing applications... ($(expr $echo0 + 1)/$apptotal)"
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> /var/log/kcl_apps.log 2>&1
    d0=$( cat $(find / -name flatpaklist.txt 2>/dev/null) | wc -l )

    declare -a d #array delta for flatpak

    for ((line=1; line<=$d0; line++))
    do
	echo "Installing applications... ($( expr $echo0 + $line + 1 )/$apptotal)"
 	flatpak=$(cat $(find / -name flatpaklist.txt 2>/dev/null) | sed -n "$line"p)
        sudo flatpak install -y flathub $flatpak >> /var/log/kcl_apps.log 2>&1
        d[$line]=$?
    done
fi

#pull from discord site
echo "Installing applications... ($(expr $apptotal - 1)/$apptotal)"
wget -q "https://discord.com/api/download?platform=linux&format=deb" >> /var/log/kcl_apps.log 2>&1
sudo chmod +x "download?platform=linux&format=deb" >> /var/log/kcl_apps.log 2>&1
sudo dpkg -i ~/'download?platform=linux&format=deb' >> /var/log/kcl_apps.log 2>&1
#e7 exit code moved to line 85

#pull from yt-dlp github page
echo "Installing applications... ($apptotal/$apptotal)"
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/bin/yt-dlp >> /var/log/kcl_apps.log 2>&1
ed1=$?
sudo chmod a+rx /usr/bin/yt-dlp >> /var/log/kcl_apps.log 2>&1
sudo yt-dlp -U >> /var/log/kcl_apps.log 2>&1

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
        echo "$(cat $(find / -name applist.txt 2>/dev/null) | sed -n "$line"p | awk -F "=" '{print $2}') successfully installed."
    else
        echo "$(cat $(find / -name applist.txt 2>/dev/null) | sed -n "$line"p | awk -F "=" '{print $2}') FAILED to install."
    fi
done



#flatpak error codes
for((line=1; line<=$d0; line++))
do
    if [ ${d[$line]} -eq 0 ]
    then
        echo "$(cat $(find / -name applist.txt 2>/dev/null) | sed -n "$line"p | awk -F "=" '{print $2}') successfully installed."
    else
        echo "$(cat $(find / -name applist.txt 2>/dev/null) | sed -n "$line"p | awk -F "=" '{print $2}') FAILED to install."
    fi
done

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

sleep 3
echo " "

#Trash cleanup
echo "Removing trash files..."
rm $(find / -name "download?platform=linux&format=deb" 2>/dev/null)
rm $(find / -name applist.txt 2>/dev/null)
rm $(find / -name flatpaklist.txt 2>/dev/null)
echo "Removing trash files... (DONE)"

sleep 3
echo " "

echo "Finished installing applications."


# linux-fresh-install
Useful apps for myself that are auto installed in a bash script. Will be updated in the future. 

Current list:

 1.tldr

2.lynis

3.nmap

4.wireshark

5.macchanger

6.vim

7.htop

8.iftop

9.testdisk

10.gh

11.xdotool

12.obs-studio

13.ffmpeg

14.tmux

15.tree

16.yt-dlp

17.discord

18.gradle

19.Flatpak
    
    a. flathub repository

    b. Steam

    c. Lutris

    d. Ultimaker Cura

    e. Arduino IDE v2

This simple script is used to get new installs of linux up to my standards ASAP. It automatically installs these applications, either via the package manager
or by directly pulling from the website and auto installing it from there. 

This script also tells you whether the application successfully installed or not, and cleans up the trash files left behind from the install.

A log file is created and contains info from the installation process of each application. Useful for debugging purposes. Located in "/var/log/kcl_apps.log".

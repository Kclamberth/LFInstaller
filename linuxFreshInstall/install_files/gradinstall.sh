#!/bin/bash

mkdir /opt/gradle
cd /opt/gradle
wget "https://services.gradle.org/distributions/gradle-8.3-bin.zip"
unzip -d /opt/gradle gradle-8.3-bin.zip
sleep 2
export PATH=$PATH:/opt/gradle/gradle-8.3/bin
sleep 2
echo " "
gradle -v

rm /opt/gradle/gradle-8.3-bin.zip

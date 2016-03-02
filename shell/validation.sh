#!/bin/bash
Date=`date +%Y_%m_%d`
echo "Uptime of Machine  `hostname` Before Reboot: `uptime | awk '{print $3,$4}' | sed s/","//` " 
echo "Running Process in  `hostname` Before Reboot" 
echo "================================================================================" 
ps -ef | grep tomcat | grep -v grep |awk '{for (i=1;i<NF;i++){print $i}}'|awk '/Dcatalina.base/'{print} | cut -d '=' -f2 >/tmp/pre_validation_$Date.txt 
ps -ef | grep mq | grep -v grep |awk '{for (i=1;i<NF;i++){print $i}}'|awk '/Dactivemq.base/'{print} | cut -d '=' -f2 >>/tmp/pre_validation_$Date.txt
ps -ef | grep was6 |grep -v grep | awk '{print $NF}' >>/tmp/pre_validation_$Date.txt
ps -ef | grep jboss | grep -v grep |awk '{for (i=1;i<NF;i++){print $i}}'|awk '/run.jar/'{print} | cut -d ':' -f1|sed s/"\/run.jar"/""/ >>/tmp/pre_validation_$Date.txt
ps -ef | grep httpd | grep -v grep | awk '{print $8}'|sort -u >>/tmp/pre_validation_$Date.txt
ps -ef | grep slapd | grep -v grep | awk '{print $10}' >>/tmp/pre_validation_$Date.txt
ps -ef | grep mule | grep -v grep | awk '{for (i=1;i<NF;i++){print $i}}'|awk '/Dmule.base/'{print} | cut -d '=' -f2 >>/tmp/pre_validation_$Date.txt 


cat /tmp/pre_validation_$Date.txt
echo "================================================================================" 


echo "YUM LOG DETAILS :-"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
/usr/bin/sudo tail -5 /var/log/yum.log 
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 

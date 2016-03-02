#!/bin/bash

diff(){
  awk 'BEGIN{RS=ORS=" "}
       {NR==FNR?a[$0]++:a[$0]--}
       END{for(k in a)if(a[k])print k}' <(echo -n "${!1}") <(echo -n "${!2}")
}


tc_count=`ps -ef | grep tomcat | grep -v grep |awk '{for (i=1;i<NF;i++){print $i}}'|awk '/Dcatalina.base/'{print} | cut -d '=' -f2 | wc -l`
#tc_count=2
if [[ $tc_count == 5 ]]
then
	echo "[`date`] [INFO] All Tomcat Process in host `hostname` are running"
else
	running_process_out=$(ps -ef | grep tomcat | grep -v grep |awk '{for (i=1;i<NF;i++){print $i}}'|awk '/Dcatalina.base/'{print} | cut -d '=' -f2)
	running_process=($running_process_out)
	tc_process=( "/app/tomcat/ams" "/app/tomcat/partnerintegration" "/app/tomcat/sinc" "/usr/local/whp-tomcat_ININ" "/app/tomcat/aps")
        missing_process=($(diff tc_process[@] running_process[@]))
	echo "[`date`] [ERROR] Tomcat Process ${missing_process[@]} in host `hostname`  is  Not Running"
fi

#!/bin/bash -x
banner "SPARK-SETUP"
i=0
for host in $(cat /home/jenkins/JenkinsCode/Production_Code/Jenkins/Demeter-Spark-Cluster-VPC/temphost.txt); do
	echo $host
	((i=i+1))
  	eval "seedexternal$i=`ssh -o 'StrictHostKeyChecking no' -i /var/lib/jenkins/arubathena/.ssh/arubathena-role.pem ubuntu@$host \"curl -s ipecho.net/plain;echo\"`"
  	ppip=`ssh -o 'StrictHostKeyChecking no' -i /var/lib/jenkins/arubathena/.ssh/arubathena-role.pem ubuntu@$host "curl -s ipecho.net/plain;echo"`
  	eval "seedinternal$i=`ssh -o 'StrictHostKeyChecking no' -i /var/lib/jenkins/arubathena/.ssh/arubathena-role.pem ubuntu@$host \"hostname -I\"`"
#        echo $i
        knife set_attribute node $host cluster_name $Clustername
        knife set_attribute node $host dc_suffix $dc_suffix
        knife set_attribute node $host dcname  $dc_name
	knife set_attribute node $host p_ipaddress $ppip
	knife node run_list add $host "role[demeter-spark],recipe[newrelic]"
done

for host in $(cat /home/jenkins/JenkinsCode/Production_Code/Jenkins/Demeter-Spark-Cluster-VPC/temphost.txt); do
 	knife set_attribute node $host seed1 $seedexternal1
 	knife set_attribute node $host seed2 $seedexternal2
 	knife set_attribute node $host seed3 $seedexternal3
 	knife set_attribute node $host seed4 $seedexternal4
	ssh -o 'StrictHostKeyChecking no' -i /var/lib/jenkins/arubathena/.ssh/arubathena-role.pem ubuntu@$host "sudo chef-client"
done


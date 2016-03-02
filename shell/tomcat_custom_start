#!/bin/sh
#
# description: Intuit SCM Tomcat init script
# @name:       tomcat
# @author:     Naohito_Takeuchi@intuit.com
# @created:    2013-07-10
# @modified:   2014-02-26
#
# chkconfig: 3 99 15
# processname: tomcat
#

scm_home=/app/tomcat
tomcat_instances=`ls -d $scm_home/*`
tomcat_user=`ls -ld $scm_home | awk '{print $3}'`
instance=$2

if [ ! -d $scm_home ]; then
  echo "$scm_home doesn't exist. Exiting init script"
  exit 1
fi

hostname=`hostname -f`
echo "Host: $hostname"
echo "Tomcat Instances: $tomcat_instances"

start() {
	echo $"Starting Tomcat Server... "
	if [ -n "$instance" ]; then
	  su - $tomcat_user -c "$scm_home/$instance/start"
	else
	  for server in $tomcat_instances; do
	    su - $tomcat_user -c ${server}/start
	  done
	fi
	return
}

startcheck() {
        echo $"Starting Tomcat Server... "
        if [ -n "$instance" ]; then
          su - $tomcat_user -c "$scm_home/$instance/startcheck"
        else
          for server in $tomcat_instances; do
            su - $tomcat_user -c ${server}/startcheck
          done
        fi
        return
}

stop() {
	echo $"Stopping Tomcat Server... "
	if [ -n "$instance" ]; then
	  su - $tomcat_user -c "$scm_home/$instance/stop"
	else
	  for server in $tomcat_instances; do
	    su - $tomcat_user -c ${server}/stop
	  done
	fi
	return
}

restart() {
	stop
	sleep 5
	start
	return
}

status() {
	return
}

# See how we were called.
case "$1" in
 start)
	start
	;;
 startcheck)
        startcheck
        ;;
 stop)
	stop
	;;
 status)
	status
	;;
 restart)
	restart
	;;
 *)
	echo $"Usage: $0 {start|startcheck|stop|status|restart}"
	exit 1
	;;
esac


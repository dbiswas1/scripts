#!/bin/bash -x

banner "REPORT-API"
DOMAIN="test.PDT1.arubathena.com"
seedinternal=`ssh -o 'StrictHostKeyChecking no' -i /var/lib/jenkins/arubathena/.ssh/arubathena-role.pem ubuntu@$BUILD_TAG.$DOMAIN "hostname -I"`
knife set_attribute node $BUILD_TAG.$DOMAIN param.master-local $seed1
knife set_attribute node $BUILD_TAG.$DOMAIN param.seed2 $seed2
knife set_attribute node $BUILD_TAG.$DOMAIN param.seed3 $seed3
knife set_attribute node $BUILD_TAG.$DOMAIN param.seed4 $seed4
knife set_attribute node $BUILD_TAG.$DOMAIN param.master $master
knife set_attribute node $BUILD_TAG.$DOMAIN param.ip $seedinternal
knife set_attribute node $BUILD_TAG.$DOMAIN param.memory $memory
knife set_attribute node $BUILD_TAG.$DOMAIN param.cpu  $cpu

knife node run_list remove $BUILD_TAG.$DOMAIN  'role[athena-basic]'
knife node run_list remove $BUILD_TAG.$DOMAIN  'role[aruba-athena]'
knife node run_list remove $BUILD_TAG.$DOMAIN  'role[arubathena-pdt-cert]'
knife node run_list remove $BUILD_TAG.$DOMAIN  'role[Exception_2_02]'

knife node run_list add $BUILD_TAG.$DOMAIN "role[arubathena-default],role[aruba-demeter],role[Demeter-api],role[arubathena-pdt-cert],"role[Exception_2_02]",recipe[newrelic]"
sudo apt-get purge postgresql-common
sudo apt-get purge postgresql-client-common
ssh -o 'StrictHostKeyChecking no' -i /var/lib/jenkins/arubathena/.ssh/arubathena-role.pem ubuntu@$BUILD_TAG.$DOMAIN "sudo chef-client"

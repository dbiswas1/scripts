#!/bin/bash

#####
# Builds a custom nginx
#
# RELEASE_TAGS="+your+tags+here"
# RELEASE_MAINTAINER="Your Name Here"
# RELEASE_MAINTAINER_EMAIL="hi@example.com"
# RELEASE_MESSAGE="Some message"
#
#####

echo "[CMD] make a source directory and cd into it"
mkdir src
cd src

echo "[CMD] get the source from debian/ubuntu"
apt-get source nginx

echo "[CMD] get the nginx version"
nginx_version=`ls -lahF .|grep nginx|grep '^d[rwx-]\{9\} '| grep '\/$'|rev|cut -d' ' -f1 | rev|sed 's/nginx-//'|sed 's/\///'`

echo "[CMD] retrieve all the nginx modules you want"
cd "nginx-${nginx_version}/debian/modules"

echo "[CMD] clone all the nginx modules from github"
git clone -q git://github.com/zebrafishlabs/nginx-statsd.git
git clone -q git://github.com/FRiCKLE/ngx_coolkit.git

cd ..

echo "[CMD] ensure the proper dependencies are in place"
cat control | sed 's/libgd2-noxpm-dev/libgd2-xpm-dev/' >> tmp ; rm control ; mv tmp control

echo "[CMD] remove unneeded and broken modules"
cat rules |sed '/with-http_image_filter_module/ d' >> tmp ; rm rules ; mv tmp rules

echo "[CMD] split up the rules file so we can rewrite it"
awk '/\$\(CONFIGURE_OPTS\)/{n++}{filename = "rule-" n ; print > filename }' rules

echo "[CMD] adding modules to the nginx-full package"
echo -e "\t    --add-module=\$(MODULESDIR)/headers-more-nginx-module \\" >> rule-
echo -e "\t    --add-module=\$(MODULESDIR)/nginx-development-kit \\" >> rule-
echo -e "\t    --add-module=\$(MODULESDIR)/nginx-lua \\" >> rule-
echo -e "\t    --add-module=\$(MODULESDIR)/nginx-statsd \\" >> rule-
echo -e "\t    --add-module=\$(MODULESDIR)/ngx_coolkit \\" >> rule-

echo "[CMD] combine all the rule files"
ls |grep rule-|while read file; do cat $file >> tmp; done; rm rules ; mv tmp rules

echo "[CMD] get the current nginx minor nginx_version"
minor_version=$(head -n 1 changelog | sed 's/ *ubuntu.*//' | sed 's/nginx (//'|cut -d '-' -f 2);
minor_version=$(($minor_version + 1));

echo "[CMD] get the current ubuntu release"
ubuntu_release=$(head -n 1 changelog| sed 's/ *\;.*//'|cut -d ' ' -f 3)

echo "[CMD] get the current time for this release"
release_time=$(date +"%a, %d %b %Y %I:%M:%S %z")

echo "[CMD] update the changelog"
echo -e "nginx (${nginx_version}-${minor_version}${RELEASE_TAGS}) ${ubuntu_release}; urgency=low

  [ ${RELEASE_MAINTAINER} ]
  * New release: ${RELEASE_MESSAGE}

 -- ${RELEASE_MAINTAINER} <${RELEASE_MAINTAINER_EMAIL}>  ${release_time}

"|cat - changelog > tmp && mv tmp changelog

echo "[CMD] Create a build"
cd ..
dpkg-buildpackage

echo "[CMD] DONE!"
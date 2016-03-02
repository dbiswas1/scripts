#Shell script to clone all repo of git

#!/bin/bash
today=`date '+%Y%m%d%H%M%S'`;
mkdir $today
cd $today

curl -v -H "Authorization: token <token to be added>“ -X GET https://api.github.com/orgs/<org_name>/repos?per_page=100 >/git_bkp/git_test.txt
cat /git_bkp/git_test.txt | grep full_name | cut -d "/" -f2 >/git_bkp/full_name.txt
sed -i 's/"//g;s/,//g' /git_bkp/full_name.txt
cat /git_bkp/full_name.txt
while read p; do
  git clone https://<access-toekn>@github.com/<org_name>/$p.git
done </git_bkp/full_name.txt

cd ~
tar -zcvf $today.tar.gz $today
#Cronjob
#0 */32 * * * /git_bkp/test2.sh

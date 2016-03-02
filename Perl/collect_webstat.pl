#!/usr/bim/perl
use DBI ;
$driver = "mysql";
$database = "oasis_page_analytics";
$dsn = "DBI:$driver:database=$database";
$userid = "root";
#$password = "test123";
$dbh = DBI->connect($dsn, $userid ) or die $DBI::errstr;


$find_cmd="/usr/bin/find /export/logs/pprdoasws300.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name \"SSL-*\"";
@file_array=`/usr/bin/find /export/logs/pprdoasws300.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name "SSL-*"`;
push(@file_array,`find /export/logs/pprdoasws301.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name "SSL-*"`);
push(@file_array,`find /export/logs/pprdoasws302.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name "SSL-*"`);
foreach $file_name (@file_array)
{
                #print  "$file_name " ;
                push(@doarray,`/bin/sh /u/dbiswas1/analytics/finddo.sh $file_name`) ;
                push(@jsparray,`/bin/sh /u/dbiswas1/analytics/findjsp.sh $file_name`);
}
                $dcount=0;
#=for comment
                foreach $doname (@doarray){
                        chomp($doname);
                        ($dopage,$doparam)=split(/\?/,$doname,2);
                        #print "Page=$dopage  Param=$doparam \n";
                        if(length($doparam) > 0){
                                $doparam=~ s/\'/\\'/g;
                                $seth = $dbh->prepare("select page_alias as p  from page_lookup where page_name=\'$dopage\'");
                                $seth->execute() or die $DBI::errstr;
                                @alias_row = $seth->fetchrow_array();
                                $do_alias=$alias_row['p'];
                                if (length($do_alias) > 0 ){
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values (\'$do_alias\',\'$dopage\',\'$doparam\',now())"); }
                                else{
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values ('NULL',\'$dopage\',\'$doparam\',now())"); }

                             }
                        else{

                                $seth = $dbh->prepare("select page_alias as p  from page_lookup where page_name=\'$dopage\'");
                                $seth->execute() or die $DBI::errstr;
                                @alias_row = $seth->fetchrow_array();
                                $do_alias=$alias_row['p'];
                                if (length($do_alias) > 0 ){
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values (\'$do_alias\',\'$dopage\',\'$doparam\',now())"); }
                                else{
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values ('NULL',\'$dopage\','',now())"); }

                            }
                        $sth->execute() or die $DBI::errstr;
                        $sth->finish();
                        $seth->finish();
                        $dcount ++;
                }
                $jcount=0;
                foreach $jspname (@jsparray){
                        chomp($jspname);
                        ($jsppage,$jspparam)=split(/\?/,$jspname,2);
                        if(length($jspparam) > 0){
                                $jspparam=~ s/\'/\\'/g;
                                $seth = $dbh->prepare("select page_alias as p  from page_lookup where page_name=\'$jsppage\'");
                                $seth->execute() or die $DBI::errstr;
                                @alias_row = $seth->fetchrow_array();
                                $jsp_alias=$alias_row['p'];
                                if (length($jsp_alias) > 0 ){
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values (\'$jsp_alias\',\'$jsppage\',\'$jspparam\',now())"); }
                                else {
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values ('NULL',\'$jsppage\',\'$jspparam\',now())"); }

                            }
                        else{
                                $seth = $dbh->prepare("select page_alias as p  from page_lookup where page_name=\'$jsppage\'");
                                $seth->execute() or die $DBI::errstr;
                                @alias_row = $seth->fetchrow_array();
                                $jsp_alias=$alias_row['p'];
                                if (length($jsp_alias) > 0 ){
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values (\'$jsp_alias\',\'$jsppage\','',now())");}
                                else {
                                $sth = $dbh->prepare("insert into page_summary (alias,page_name,page_param,date_p ) values ('NULL',\'$jsppage\','',now())");}

                            }

                        $sth->execute() or die $DBI::errstr;
                        $sth->finish();
                        #print "Page=$jsppage  Param=$jspparam \n";
                        $seth->finish();
                        $jcount ++;
                }
#print "Total Jsp Count = $jcount";
#print "\n Total do Count = $dcount";

$dbh->disconnect;
#=cut


#!/usr/bim/perl
use DBI ;
$driver = "mysql";
$database = "oasis_page_analytics";
$dsn = "DBI:$driver:database=$database";
$userid = "root";
#$password = "test123";
$dbh = DBI->connect($dsn, $userid ) or die $DBI::errstr;


$find_cmd="find /export/logs/pprdoasws300.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name \"SSL-*\"";
@file_array=`find /export/logs/pprdoasws300.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name "SSL-*"`;
push(@file_array,`find /export/logs/pprdoasws301.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name "SSL-*"`);
push(@file_array,`find /export/logs/pprdoasws302.corp.intuit.net/opt/ihs6/logs  -maxdepth 1 -mtime -1 -type f -name "SSL-*"`);
foreach $file_name (@file_array)
{
                #print  "$file_name " ;
                push(@doarray,`sh finddo.sh $file_name`) ;
                push(@jsparray,`sh findjsp.sh $file_name`);
}
                $dcount=0;
#=for comment
                foreach $doname (@doarray){
                        chomp($doname);
                        ($dopage,$doparam)=split(/\?/,$doname,2);
                        #print "Page=$dopage  Param=$doparam \n";
                        if(length($doparam) > 0){
                                $doparam=~ s/\'/\\'/g;
                                $sth = $dbh->prepare("insert into page_summary (page_name,page_param,date_p ) values (\'$dopage\',\'$doparam\',now())"); }
                        else{
                                $sth = $dbh->prepare("insert into page_summary (page_name,page_param,date_p ) values (\'$dopage\','',now())");}
                        $sth->execute() or die $DBI::errstr;
                        $sth->finish();
                        $dcount ++;
                }
                $jcount=0;
                foreach $jspname (@jsparray){
                        chomp($jspname);
                        ($jsppage,$jspparam)=split(/\?/,$jspname,2);
                        if(length($jspparam) > 0){
                                $jspparam=~ s/\'/\\'/g;
                                $sth = $dbh->prepare("insert into page_summary (page_name,page_param,date_p ) values (\'$jsppage\',\'$jspparam\',now())");}
                        else{
                                $sth = $dbh->prepare("insert into page_summary (page_name,page_param,date_p ) values (\'$jsppage\','',now())");}
                        $sth->execute() or die $DBI::errstr;
                        $sth->finish();
                        #print "Page=$jsppage  Param=$jspparam \n";
                        $jcount ++;
                }
#print "Total Jsp Count = $jcount";
#print "\n Total do Count = $dcount"; 


$dbh->disconnect;
#=cut


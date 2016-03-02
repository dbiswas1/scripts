#!/usr/bim/perl
use DBI ;
$driver = "mysql";
$database = "oasis_page_analytics";
$dsn = "DBI:$driver:database=$database";
$userid = "root";
#$password = "test123";
$dbh = DBI->connect($dsn, $userid ) or die $DBI::errstr;

$sel=$dbh->prepare("select page_name,alias,count(*) as count from page_summary where date_format(date_p,\'%Y-%m-%d\')=CURDATE() group by page_name order by count desc limit 0,50");
$sel->execute();
open(report_file, '>/u/dbiswas1/analytics/daily_report.csv');
$sel->bind_columns(\($col1, $col2, $col3));
while($sel->fetch){
print report_file "$col1,$col2,$col3 \n";

}
close(report_file);
$sel->finish();
$dbh->disconnect;


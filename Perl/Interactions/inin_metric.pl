#!/usr/bin/perl
use strict;
use DBI;
use POSIX;
use MIME::Lite;

#################################################
#This Script is used to colllect the ININ metric
#This will run everyday at 1900 PST time
#Author Deepak Biswas
#################################################

my @months= qq{JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC};
my $current_date=POSIX::strftime( "%d-%h-%y", localtime());
#$current_date='05-FEB-14';
$current_date=uc($current_date);


##########################################
# Establish DB Connection				 #
##########################################

my $dbh=DBI->connect(	'dbi:Oracle:oasis',
						'dbiswas',
						'Ninja123',
						) || die "Database connection cannot establish : $DBI::errstr";
						
my $message_body;
my $total_inetraction=0;
my $i_f_inquiries=0;
my $i_created=0;
my $i_for_case=0;
my $i_sr_case=0;
my $i_n_sr_case=0;
my $i_e_sr_case=0;
my $i_o_sr_case=0;
my $other_interaction=0;

##########################################
# Open Propert file and execute Query    #
##########################################
open(PROP_FILE,'/u/dbiswas1/Interactions/sql.properties') || die "cannot open the file";
while (<PROP_FILE>){
chomp;


	if (! $_ =~ /^$/) {
	my($label,$query) = split(/:/,$_);
	$query=~s/current_date/$current_date/g;
	#print "$query \n";

		#my $label="$query"; 
		my $lb_h = $dbh->prepare($query);
		$lb_h->execute();
		my $count ;
		$lb_h->bind_columns(undef, \$count);
		while($lb_h->fetch()){
			if($label =~ 'TOTAL INTERACTIONS')
			{
				$total_inetraction=$count;
				
			}
			
			if($label =~ 'INQUIRIES INTERACTIONS')
			{
				$i_f_inquiries=$count;
			}
			
			if($label =~ 'INQUIRIES CREATED')
			{
				$i_created=$count;
			}
			
			if($label =~ 'CASE INTERACTIONS')
			{
				$i_for_case=$count;
				
			}
			
			if($label =~ 'SR CASES WITH INTERACTION')
			{
				$i_sr_case=$count;
				
			}
			
			if($label =~ 'NEW SR CASES WITH INTERACTION')
			{
				$i_n_sr_case=$count;
				
			}
			
			if($label =~ 'EXISTING SR CASES WITH INTERACTION')
			{
				$i_e_sr_case=$count;
				
			}
			
			if($label =~ 'OTHER CASES WITH INTERACTION')
			{
				$i_o_sr_case=$count;
				
			}
			
			if($label =~ 'OTHER INTERACTIONS')
			{
				$other_interaction=$count;
				
			}
			
			
			
			
			
			
			
			
			$message_body.="$label Count is = $count \n";
		}#End of sql while
	
	}#End of if
}# End of While(File Handler)


close(PROP_FILE);

$dbh->disconnect;


##########################################
# Sending Mail							 #
##########################################

my $subject = "ININ DAILY REPORT $current_date";
open(MAIL_FILE,'/u/dbiswas1/Interactions/mail_recipents.txt') || die "cannot open a file";
while (<MAIL_FILE>){
	chomp;
	if(! $_ =~ /^$/){
		
	my $msg = MIME::Lite->new(
     From    => 'ININ_Report@intuit.com',
     To      => $_,
     Subject => $subject,
     Type    => 'text/html',
     Data    => << "EOHTML"
<table border="1" style="width:400px">
<tr>
  <td><b><font face="Cambria" color="red">TOTAL INTERACTIONS</font></b></td>
  <td align="right"><b><font face="Cambria" color="red">$total_inetraction</font></b></td>
</tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr>
  <td><b><font face="Cambria">INTERACTIONS FOR INQUIRIES</font></b></td>
  <td align="right"><b><font face="Cambria">$i_f_inquiries</font></b></td>
</tr>
<tr>
  <td><font face="Cambria">INQUIRIES CREATED</font></td>
  <td align="right"><font face="Cambria">$i_created</font></td>
</tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr>
  <td><b><font face="Cambria">INTERACTIONS FOR CASE</font></b></td>
  <td align="right"><b><font face="Cambria">$i_for_case</font></b></td>
</tr>
<tr>
  <td> <font face="Cambria">&nbsp;&nbsp;&nbsp;&nbsp;INTERACTIONS FOR SR CASE</font></td>
  <td align="right"><font face="Cambria">$i_sr_case</font></td>
</tr>
<tr>
  <td><font face="Cambria"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INTERACTIONS FOR NEW SR CASE</font></td>
  <td align="right"><font face="Cambria">$i_n_sr_case</font></td>
</tr>
<tr>
  <td> <font face="Cambria">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INTERACTIONS FOR EXISTING SR CASE</font></td>
  <td align="right"><font face="Cambria">$i_e_sr_case</font></td>
</tr>
<tr>
  <td> <font face="Cambria">&nbsp;&nbsp;&nbsp;&nbsp; INTERACTIONS FOR OTHER CASES</font></td>
  <td align="right"><font face="Cambria">$i_o_sr_case</font></td>
</tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr></tr>
<tr>
  <td><b><font face="Cambria">OTHER INTERACTIONS</font></b></td>
  <td align="right"><b><font face="Cambria">$other_interaction</font></b></td>
</tr>
</table> 
EOHTML
);

$msg->send();
		}
}

exit;


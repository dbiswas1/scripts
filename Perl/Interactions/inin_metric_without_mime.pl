#!/usr/bin/perl
use strict;
use DBI;
use POSIX;

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
			$message_body.="$label Count is = $count \n";
		}#End of sql while
	
	}#End of if
}# End of While(File Handler)


close(PROP_FILE);

$dbh->disconnect;


##########################################
# Sending Mail							 #
##########################################


open(MAIL_FILE,'/u/dbiswas1/Interactions/mail_recipents.txt') || die "cannot open a file";
while (<MAIL_FILE>){
	chomp;
	if(! $_ =~ /^$/){
		
		my $from = 'ININ_Report@intuit.com';
		my $subject = "ININ DAILY REPORT $current_date";

 
		open(MAIL, "|/usr/sbin/sendmail -t");
 
		# Email Header
		print MAIL "To: $_\n";
		print MAIL "From: $from\n";
		print MAIL "Subject: $subject\n\n";

		# Email Body
		print MAIL $message_body;

		close(MAIL);
		}
}

exit;


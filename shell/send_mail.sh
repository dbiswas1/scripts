#!/usr/bin/bash
/usr/bin/uuencode /u/dbiswas1/analytics/daily_report.csv daily_report.`/bin/date  +%b-%d-%Y`.csv | /bin/mailx -s "Daily Report `/bin/date  +%b-%d-%Y`"  deepak_biswas@intuit.com,veeresh_sondankar@intuit.com


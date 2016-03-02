#prequisite  pip install BeautifulSoup
#http://stackoverflow.com/questions/17154393/multiple-levels-of-keys-and-values-in-python
#http://stackoverflow.com/questions/15250455/how-to-parse-html-table-with-python-and-beautifulsoup-and-write-to-csv
#!/usr/bin/python

from lxml import html
from lxml.html import parse
from pprint import pprint
import requests
import urllib2
from BeautifulSoup import BeautifulSoup 
from collections import defaultdict


spark_master='http://jenkins-demeter-spark-cluster-vpc-7-1-uswest2.arubathena.com:7080'

page=urllib2.urlopen(spark_master).read()


soup = BeautifulSoup(page)

div = soup.find("div", { "class" :"container-fluid"})

page_feilds=defaultdict( lambda: defaultdict(lambda: defaultdict( int )))
tbl=0
for table in div.findAll("table"):
    tbl=tbl+1
    rw=0
    
    for row in table.findAll("tr"):
        rw=rw+1
        col=0
        cells = row.findAll("td")
      
        for field in cells:
            col=col+1
            page_feilds[tbl][rw][col]=field.text
         
        
#print page_feilds

print "----Workers Status Report Start-----"
print page_feilds[1][1][1], ":" , page_feilds[1][1][3]
print page_feilds[1][2][1], ":" , page_feilds[1][2][3] 
print page_feilds[1][3][1], ":" , page_feilds[1][3][3] 
print page_feilds[1][4][1], ":" , page_feilds[1][4][3] 
print "----Workers Status Report End-----"

print "----Context Present Start------"
print "Context : ", page_feilds[2][1][2]
print "----Context Present End------"



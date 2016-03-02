#!/usr/bin/python

import json
import urllib2
spark_master='http://jenkins-demeter-athena-env-build-33.test.pdt1.arubathena.com:8090/jobs'
json_response=urllib2.urlopen(spark_master).read()

from pprint import pprint
json_data=json.loads(json_response)
status_count=0
exception_list = dict()

for result in json_data:

    if result['status'] == 'ERROR':
        status_count=1
        exception_list[result['jobId']] = result['result']['message']
        
if status_count == 0:
    print 0
else:
    pprint(exception_list)   
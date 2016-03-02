#!/bin/bash -X

curl -u demeter:demeter http://jobserver-uswest1.arubathena.com:9080/jobs | grep "Failed"

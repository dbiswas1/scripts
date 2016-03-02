grep "\.do" $1  | grep -v "File does not exist" |awk '{print $7}'

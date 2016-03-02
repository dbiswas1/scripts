#two ways

dict01=dict(name='bob', job='dev', age=40)
print "normal",dict01

diczip=dict(zip(['name','job','age'],['bob','dev',40]))
print "Zipping Explained",diczip

#Explain Nested

record={ 'name':{'first':'deepak','last':'biswas'},
         'job':['devops','manager'],
         'age':30
        }
print record

print record['name']
print record['name']['last']
print record['job']
#record['job'].append=('presales')
print record

#to check if key exist
key_exist='name' in record
print "key exist: ", key_exist
key_not_exist='name11' in record
print "key exist: ", key_not_exist

if not 'name' in record:
    print "key not found"

print record.keys()
skey=list(record.keys())
skey.sort()
print skey

#little on performance cae1 has better performance than case 2

#Case1
perlis1=[(x**2) for x in [1,2,3,4]]
print perlis1

#Case2
perlist2=[]
for x in [1,2,3,4]:
    perlist2.append(x**2)
print perlist2

print "bot printed same result but Case1 is better in performance"

import re
print "Goodbye, World!"
s ="test"
l=list(s)

l[2]='r'

print l
print '-'.join(l)

print len(s)
print s[len(s)-2]

B=bytearray(b'spam')
print B
B.extend(b'eggs')
print B
bytearray(b'spameggs')
print B.decode()


z= "Test amar Test"
print z.replace(' ','')
print len(z)
print '{1},tame, added, {2}'.format('Test', 'amar' ,'Test')

print z.find('tatat')

line2 = "This text contains one pattern"
matc=re.match("(.*)one (.*)",line2)
print matc.group(2)

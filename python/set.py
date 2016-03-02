a=set([1,2,3,4,5,6])
b=set([5,6,1,9,0,77])

#print ("SEt A:" a)
print "SET A", a
print "SET B", b
print "Union of A and B", ( a.union(b))
print "Intersection of A and B",(a.intersection(b))

i=0 
for i in range (0,10) :
    print i
    i += 1
 
print "Length of Set A",len(a)
    
for setid in a:
    if setid <= 3 :
        print "Set Value <=3 ",(setid)
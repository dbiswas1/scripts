l=['dep','135',5628,8.9]
print l[:2]

print l * 3

print l[(len(l)-1)]

#mULTIDEIMENISONAL ARRAY (lists of list)

l1=[[1,2,3],
    [4,5,6],
    [7,8,9]]

#Row Operation
print l1[2][1]

#Column Operation what below says is give the first element of each row in comprehsnsion
col1=[row[0] for row in l1]
print col1

#mix for and i filter out odd

col2=[row[1] for row in l1 if row[1] % 2 == 0]
print col2

#Further maniuplation of list
rlist=list(range(5))
rlist1=list(range(-4,5,2))
print "rlist =", rlist
print "rlist1=", rlist1
m1=[[a , a*2,a/2.0] for a in range(4)]
print m1

#Sum Operation in lIst
m22=[[1,2,3],
     [4,5,6],
     [7,8,9]]

#Summing up each roW
sr=[sum(i) for i in m22]
print sr

#Print with row number

sr1={ i:sum(m22[i]) for i in range(3)}
print sr1






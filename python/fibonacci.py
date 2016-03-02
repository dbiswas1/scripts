n= int(5)
print 0
print 1
cur= int(1)
prev=int(1)
fut= int(0)
for x in range(0,n):
    fut = cur + prev
    print  fut
    prev=cur
    cur=fut

sn=0
eno=7
def fib(n):
    if n < 2 :
        return n

    return fib(n-2) + fib(n-1)

print map(fib, range(sn,eno))

    #print "current %d" %(cur)
    #print "prev %d" %(prev)

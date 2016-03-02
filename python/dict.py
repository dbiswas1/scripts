#Use of Dictonary
#!/usr/bin/python
import sys

dict1={ 'bloody_marry' : {'vodka','gin','wine'},
		'margareeta' : {'whisky','water'}				
	  }

for cocktail, ing in dict1.items():
    if len(sys.argv) == 0:
        print ("Invalid Ask")
    elif sys.argv[1] in ing:
	    print (cocktail)
    
	

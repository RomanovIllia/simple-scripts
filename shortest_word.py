#find shortest word in a string

def find_short(s):
    b=500
    for word in s.split(" "):
        a = len(word)
        if b>=a:
        	b=a

    return print (b)
find_short(input("type string: \n"))
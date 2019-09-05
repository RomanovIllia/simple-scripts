#reverse words task
#solution for https://leetcode.com/problems/reverse-words-in-a-string-iii/

def reverse_words(text):
   
    result = []
    for word in text.split(" "):
        result.append(word[::-1])      
    return print(' '.join(result)) 

reverse_words(text=input("print string\n"))
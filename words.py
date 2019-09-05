#reverse words task
#solution for https://leetcode.com/problems/reverse-words-in-a-string-iii/

def reverse_words(text):
   
    result = []
     # разбить по пробелам .split() thank you SO
    for word in text.split(" "):
    	# развернуть каждое слово word[::-1]
        result.append(word[::-1])  
        # склеить в строку ' '.join(["vanya", "petya"])    
    return print(' '.join(result)) 

reverse_words(text=input("print string\n"))
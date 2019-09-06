def duplicate_count(text):

	x = 0
	array = list(text)
	newdict = {}
	for letter in array:
		newdict.update({letter: array.count(letter)})
	print(newdict)
	for value in newdict:
		if newdict.get(value) > 1:
			x = x+1
			print(value, x)
	return print(x)

duplicate_count(input("insert the word\n"))

#solution for https://www.codewars.com/kata/counting-duplicates/train/python

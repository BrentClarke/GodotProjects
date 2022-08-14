extends Node


func generate(length):
	var combination = []
	
	for number in range(length):
		randomize()
		combination.append(randi() % 10)
	
	return combination
	
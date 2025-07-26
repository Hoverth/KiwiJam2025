extends Control

func selectSeed() -> Array:
	var genRandom = RandomNumberGenerator.new()
	var seedValue = genRandom.randi_range(0,8)
	
	# given  as: 
	# red    - 1
	# green  - 2
	# blue   - 3
	# yellow - 4
	
	var possibleStates : Array[Array] = [
	 [1,2,1], [3,3,3], [1,1,1],
	 [4,2,4], [3,1,2], [3,3,1],
	 [1,1,2], [2,2,4], [3,2,2]
	]
	
	return possibleStates[int(seedValue)]
		
func displaySignals(seedArray) -> void:
	for value in range(3):
		if seedArray[value] == 1:
			print("red")
		elif seedArray[value] == 2:
			print("green")
		elif seedArray[value] == 3:
			print("blue")
		elif seedArray[value] == 4:
			print("yellow")

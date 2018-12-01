extends Control

# class member variables go here, for example:
var paths = [] 

func _ready():
	randomize()

func get_path(var index) :
	if (index <= paths.size()) :
		return null
	return paths[index]

func get_random_path() :
	if (paths.empty()) :
		return null
	return paths[rand_range(0, paths.size())]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

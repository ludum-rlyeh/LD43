extends Control

# class member variables go here, for example:
var paths = [
		[Vector2(100,0), Vector2(100,100), Vector2(200,200)], 
		[Vector2(200,0), Vector2(200,100), Vector2(200,200)], 
		[Vector2(300,0), Vector2(300,100), Vector2(800,800)]
	] 
export (PackedScene) var enemi_scene

func _ready():
	randomize()
	var nb = rand_range(10, 20)
	for i in range(nb):
		var enemi = enemi_scene.instance()
		enemi.set_path(get_random_path())
		enemi.set_speed(rand_range(60, 120))
		add_child(enemi)

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

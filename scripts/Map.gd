extends Control

const CELL_SIZE = 64

var paths = [
	[CELL_SIZE*Vector2(4,0), CELL_SIZE*Vector2(4,5), CELL_SIZE*Vector2(8,5), CELL_SIZE*Vector2(8,8), CELL_SIZE*Vector2(6,8), CELL_SIZE*Vector2(6,10)]
]
 
export (PackedScene) var enemi_scene

func _ready():
	randomize()
	var nb = rand_range(10, 20)
	for i in range(nb):
		var enemi = enemi_scene.instance()
		enemi.set_path(get_random_path())
		enemi.set_speed(rand_range(30, 60))
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

extends Control


var paths = [
	[Vector2(3,0), Vector2(3,4), Vector2(6,4), Vector2(6,7), Vector2(4,7), Vector2(4,9)],
	[Vector2(12,0), Vector2(12,1), Vector2(10,1), Vector2(10,5), Vector2(6,5), Vector2(6,7), Vector2(4,7), Vector2(4,9)]
]

export (PackedScene) var enemi_scene

var matrix = []

func _ready():
	randomize()
	var nb = 10 #rand_range(10, 20)
	for i in range(nb):
		var enemi = enemi_scene.instance()
		enemi.set_path(get_random_path())
		enemi.set_speed(rand_range(60, 120))
		add_child(enemi)
		
	var i = 0
	while($TileMap.get_cell(i, 0) != -1):
		i += 1
	self.matrix.resize(i)
	i = 0
	while($TileMap.get_cell(0, i) != -1):
		i += 1
	for j in range(matrix.size()):
		matrix[j] = []
		matrix[j].resize(i)
		for k in range(matrix[j].size()):
			if $TileMap.get_cell(j, k) == 9 || $TileMap.get_cell(j, k) == 8:
				matrix[j][k] = global.PATH_TILE
			elif $TileMap.get_cell(j, k) == 10 || $TileMap.get_cell(j, k) == 11:
				matrix[j][k] = global.SOCKET_TILE
			else :
				print($TileMap.get_cell(j, k))
#	TEST selectionner
#	var tower = load("res://scenes/Turret.tscn").instance()
#	$SocketSelectioner.enable(tower)

func get_path(var index) :
	if (index <= paths.size()) :
		return null
	return paths[index]

func get_random_path() :
	if (paths.empty()) :
		return null
	return paths[rand_range(0, paths.size())]
	
func on_add_object(var index, var object):
	add_child(object)
	object.set_position(global.index_to_position(index, global.CELL_SIZE))
	update_matrix(index, 2)
	get_node("SocketSelectioner").disable()
	
func update_matrix(index, type):
	matrix[index.x][index.y] = type
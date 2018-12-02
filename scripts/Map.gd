extends Control

signal wave_enemis_finished_signal
signal game_over_signal


var paths = [
	[Vector2(3,0), Vector2(3,4), Vector2(6,4), Vector2(6,7), Vector2(4,7), Vector2(4,9)],
	[Vector2(12,0), Vector2(12,1), Vector2(10,1), Vector2(10,5), Vector2(6,5), Vector2(6,7), Vector2(4,7), Vector2(4,9)]
]

export (PackedScene) var enemi_scene

var buildings_scenes = [preload("res://scenes/Turret.tscn")]

var tower_menu_scene = preload("res://scenes/TowerMenu.tscn")
var tower_menu

var matrix = []

func _ready():
	randomize()
	
	tower_menu = tower_menu_scene.instance()
	add_child(tower_menu)
	tower_menu.connect("asking_batiment_creation", self, "add_building_to_map")
	tower_menu.hide()
	
	var  village = self.get_node("Village")
	village.connect("sacrifice_signal", self, "apply_sacrifice")
	
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

func on_cell_clicked(var index):
	if matrix[index.x][index.y] == global.SOCKET_TILE:
		tower_menu.set_position(global.index_to_position(index, global.CELL_SIZE))
		tower_menu.show()
	#afficher menu construction à l'emplacement

func add_object_to_map(var object, var index):
	add_child(object)
	object.set_position(global.index_to_position(index, global.CELL_SIZE))
	update_matrix(index, 2)
#	get_node("SocketSelectioner").disable()

func add_building_to_map(var type):
	var building = self.buildings_scenes[type].instance()
	var index = global.position_to_index(self.tower_menu.rect_position, global.CELL_SIZE)
	add_object_to_map(building, index)

func update_matrix(index, type):
	matrix[index.x][index.y] = type

#ajouter le type pour le type d'ennemi
func spawn_enemis(var nb_enemis, var type):
	for i in range(nb_enemis):
		var enemi = enemi_scene.instance()
		enemi.set_path(get_random_path())
		enemi.set_speed(rand_range(60, 120))
		enemi.connect("enemi_died_signal", self, "on_enemi_died")
		enemi.connect("finish_path_signal", self, "on_enemi_arrived")
		add_child(enemi)

func on_enemi_died(var enemi):
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.empty():
		emit_signal("wave_enemis_finished_signal")

func on_enemi_arrived(var enemi):
	enemi.die()
	#A changer
	$Village.remove_paysans(enemi.nb_paysans_to_kill)

func _on_game_over_signal():
	emit_signal("game_over_signal")

func apply_sacrifice(var type):
	if(type == global.SACRIFICE_TYPE.THORNS) :
		apply_thorns()
	elif(type == global.SACRIFICE_TYPE.LIGHTNING) :
		apply_lightning()
	elif(type == global.SACRIFICE_TYPE.BLIZZARD) :
		apply_blizzard()
	elif(type == global.SACRIFICE_TYPE.METEORS) :
		apply_meteors()

func apply_thorns() :
	var timer = get_tree().create_timer(10, false)
	timer.connect("timeout", self, "end_thorns")
	get_tree().call_group("Enemis", "stuned")

func end_thorns() :
	get_tree().call_group("Enemis", "unstuned")

func apply_lightning() :
	print("TODO")

func apply_blizzard() :
	print("TODO")

func apply_meteors() :
	print("TODO")
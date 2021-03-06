extends Control

signal wave_enemis_finished_signal
signal game_over_signal
signal win_signal

var speed_camera = 10
var zoom_scroll = Vector2(0.05, 0.05)
var clamp_zoom = [Vector2(1,1), Vector2(2.1,2.1)]


var paths = [
	[Vector2(3,0), Vector2(3,4), Vector2(6,4), Vector2(6,7), Vector2(4,7), Vector2(4,9)],
	[Vector2(12,0), Vector2(12,1), Vector2(10,1), Vector2(10,5), Vector2(6,5), Vector2(6,7), Vector2(4,7), Vector2(4,9)]
]
var enemis_waves = []
var nb_waves

var meteor_scene = preload("res://scenes/meteor.tscn")
var enemi_scene = preload("res://scenes/Enemi.tscn")
var enemi_boss_scene = preload("res://scenes/EnemiBoss.tscn")

var buildings_scenes = { 
	global.TURRET : preload("res://scenes/DeerTurret.tscn"),
	global.WIZARD : preload("res://scenes/OwlTurret.tscn"),
	global.CANON : preload("res://scenes/BoarTurret.tscn"),
	global.FARM: preload("res://scenes/Farm.tscn")
}

var tower_menu_scene = preload("res://scenes/TowerMenu.tscn")
var tower_menu

var phantom
var matrix = []

var spawner = []

var size_map = Vector2(0,0)


func _process(delta):
	var position = global.current_camera.get_position()
	
	if Input.is_action_pressed("ui_right"):
		position = Vector2(position.x + speed_camera, position.y)
	elif Input.is_action_pressed("ui_left"):
		position = Vector2(position.x - speed_camera, position.y)
	elif Input.is_action_pressed("ui_up"):
		position = Vector2(position.x, position.y - speed_camera)
	elif Input.is_action_pressed("ui_down"):
		position = Vector2(position.x, position.y + speed_camera)
	elif Input.is_action_pressed("zoom_camera_avant"):
		global.current_camera.set_zoom(Vector2(clamp(global.current_camera.zoom.x + zoom_scroll.x, self.clamp_zoom[0].x, self.clamp_zoom[1].x), clamp(global.current_camera.zoom.y + zoom_scroll.y, self.clamp_zoom[0].y, self.clamp_zoom[1].y)))
	elif Input.is_action_pressed("zoom_camera_arriere"):
		global.current_camera.set_zoom(Vector2(clamp(global.current_camera.zoom.x - zoom_scroll.x, self.clamp_zoom[0].x, self.clamp_zoom[1].x), clamp(global.current_camera.zoom.y - zoom_scroll.y, self.clamp_zoom[0].y, self.clamp_zoom[1].y)))
	global.current_camera.set_position(position)
	recenter_camera()
	

func recenter_camera():
	var trans_camera = global.current_camera.get_canvas_transform()
	var min_pos = -trans_camera.get_origin() / trans_camera.get_scale()
	
	var view_size = get_viewport_rect().size / trans_camera.get_scale()
	var max_pos = min_pos + view_size
	
	var diff_vec = max_pos - (self.size_map - Vector2(32,32))
	
	if diff_vec.x > 0.0:
		global.current_camera.set_position(global.current_camera.position - Vector2(diff_vec.x, 0))

	if diff_vec.y > 0.0:
		global.current_camera.set_position(global.current_camera.position - Vector2(0, diff_vec.y))
	
	diff_vec = min_pos - Vector2(-32,-32)
	
	if diff_vec.x < 0.0:
		global.current_camera.set_position(global.current_camera.position - Vector2(diff_vec.x, 0))

	if diff_vec.y < 0.0:
		global.current_camera.set_position(global.current_camera.position - Vector2(0, diff_vec.y))

func _ready():
	randomize()
	
	set_process(true)
	
	tower_menu = tower_menu_scene.instance()
	add_child(tower_menu)
	
	tower_menu.connect("asking_batiment_creation", self, "on_asking_batiment_creation")
	tower_menu.connect("print_phantom", self, "on_print_phantom")
	tower_menu.connect("hide_phantom", self, "on_hide_phantom")
	
	tower_menu.hide()
	
	var  village = self.get_node("Village")
	village.connect("change_nb_caillasse_signal", self, "on_change_nb_caillasse")
	village.connect("sacrifice_signal", self, "apply_sacrifice")
	village.connect("game_over_signal", self, "game_over_signal")
	
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
			else:
				matrix[j][k] = global.OTHER_TILE
				
	self.size_map = Vector2(matrix.size() * global.CELL_SIZE, matrix[0].size() * global.CELL_SIZE)
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

func on_asking_batiment_creation(var type):
	var price = global.TOWER_PRICES[type]
	if($Village.caillasse >= price):
		$Village.decrease_caillasse(price)

		var building = self.buildings_scenes[type].instance()
		var index = global.position_to_index(self.tower_menu.rect_position, global.CELL_SIZE)
		add_object_to_map(building, index)
		if type == global.TOWER_TYPE.FARM:
			$Village.add_farm(building.capacity)
		
	if self.phantom != null:
		hide_phantom()

func on_print_phantom(type):
	var building = self.buildings_scenes[type].instance()
	var index = global.position_to_index(self.tower_menu.rect_position, global.CELL_SIZE)
	self.phantom = building
	var price = global.TOWER_PRICES[type]
	
	var can_buy = $Village.caillasse >= price
	building.set_phantom(can_buy)
	
	add_child(building)
	building.set_position(global.index_to_position(index, global.CELL_SIZE))

func on_change_nb_caillasse(caillasse):

	if self.phantom != null:
		var price = global.TOWER_PRICES[phantom.type]
		var can_buy = $Village.caillasse >= price
		phantom.set_phantom(can_buy)
	
func on_hide_phantom():
	self.hide_phantom()

func hide_phantom():
	if self.phantom != null:
		self.call_deferred("remove_child", self.phantom)
		self.phantom.call_deferred("queue_free")
		self.phantom = null
	
func update_matrix(index, type):
	matrix[index.x][index.y] = type

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == BUTTON_RIGHT and event.pressed:
			tower_menu.hide()
			self.hide_phantom()


#ajouter le type pour le type d'ennemi
func spawn_enemis():
	if self.enemis_waves.empty():
		emit_signal("win_signal")
	else:
		var next_wave = self.enemis_waves.front()
		var enemi
		for i in range(next_wave.nb_enemis_de_base):
			enemi = enemi_scene.instance()
			enemi.set_path(get_random_path())
			enemi.connect("enemi_died_signal", self, "on_enemi_died")
			enemi.connect("finish_path_signal", self, "on_enemi_arrived")
			self.spawner.append(enemi)
		for i in range(next_wave.nb_enemis_boss):
			enemi = enemi_boss_scene.instance()
			enemi.set_path(get_random_path())
			enemi.connect("enemi_died_signal", self, "on_enemi_died")
			enemi.connect("finish_path_signal", self, "on_enemi_arrived")
			self.spawner.append(enemi)
		$TimerSpawnEnemi.set_wait_time(next_wave.cadence_spawn)
		$TimerSpawnEnemi.start()
		
func pop_enemis_on_map_from_spawner():
	var enemi = self.spawner.front()
	call_deferred("add_child", enemi)
	spawner.pop_front()
	if !spawner.empty():
		$TimerSpawnEnemi.start()

func on_enemi_died(var enemi):
	var enemies = get_tree().get_nodes_in_group("Enemis")
	print(enemies)
	print(enemies.size())
	if enemies.size() <= 1:
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
	var thorns_duration = 10 # seconds
	var timer = get_tree().create_timer(thorns_duration, false)
	timer.connect("timeout", self, "end_thorns")
	#Music
	self.get_parent().on_blizzard()
	timer.connect("timeout", self.get_parent(), "on_end_blizzard")
	get_tree().call_group("Enemis", "stuned")

func end_thorns() :
	get_tree().call_group("Enemis", "unstuned")

func apply_lightning() :
	var lightning_duration = 10 # second
	# MUSIC (To change)
	var timer_music = get_tree().create_timer(lightning_duration, false)
	timer_music.connect("timeout", self.get_parent(), "on_end_blizzard")
	self.get_parent().on_blizzard()
	# Ambient animation
	change_filter(Color(0.5,0.5,0.7,1.0))
	play_filter(lightning_duration+1)
	for i in range(1,lightning_duration+1) :
		var timer = get_tree().create_timer(rand_range(i,i+1),false)
		timer.connect("timeout", self, "call_lightning")

func call_lightning() :
	var enemies = get_tree().get_nodes_in_group("Enemis")
	if !enemies.empty() :
		$ColorRect.show()
		enemies[rand_range(0, enemies.size())].on_lightning()

func apply_blizzard() :
	var blizzard_time = 30 # second
	# MUSIC
	var timer = get_tree().create_timer(blizzard_time, false)
	timer.connect("timeout", self.get_parent(), "on_end_blizzard")
	self.get_parent().on_blizzard()
	# Animation
	$Blizzard.init(0.01, blizzard_time)
	$Blizzard.start()
	# Effect
	change_filter(Color(0.6,0.6,0.6,1))
	play_filter(blizzard_time+1)
	var enemies = get_tree().get_nodes_in_group("Enemis")
	for e in enemies :
		e.slow_down(0.25, blizzard_time)

func apply_meteors() :
	var time = 20 # seconds
	# MUSIC
	var timer_music = get_tree().create_timer(time, false)
	timer_music.connect("timeout", self.get_parent(), "on_end_blizzard")
	self.get_parent().on_blizzard()
	# Ambient
	change_filter(Color(0.7,0.5,0.5,1))
	play_filter(time+1)
	# Effect
	for i in range(1,time+1) :
		var timer = get_tree().create_timer(rand_range(i,i+1),false)
		timer.connect("timeout", self, "call_meteor")

func call_meteor() :
	var meteor = meteor_scene.instance()
	add_child(meteor)
	var map_rect = self.get_node("TileMap").get_used_rect()
	var pos = Vector2(rand_range(0,map_rect.size.x),rand_range(0,map_rect.size.y))
	var timer = get_tree().create_timer(2,false)
	var time = 2
	timer.connect("timeout", self, "damage_in_zone")
	pos *= global.CELL_SIZE
	meteor.init(Vector2(1000, 0), pos, time, 3)
	meteor.start()
	damage_in_zone(pos, 1000, 200)

func damage_in_zone(var center, var radius, var power) :
	var enemies = get_tree().get_nodes_in_group("Enemis")
	for e in enemies :
		if center.distance_to(e.position) < radius :
			e.take_damages(power)
			
func change_filter(var color):
	$AnimationPlayer.get_animation("storm").track_set_key_value(0,1, color)
	$AnimationPlayer.get_animation("storm").track_set_key_value(0,2, color)
	
func play_filter(var time):
	$AnimationPlayer.play("storm", 1.0, 1.0 / (time/10.0))

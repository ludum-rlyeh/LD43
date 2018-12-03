extends Node2D

var play_theme = {"BlizzardStreamPlayer": false}

var map_scene = preload("res://scenes/Level1.tscn")
var game_over = load("res://scenes/GameOver.tscn").instance()
var main_menu = load("res://scenes/MainMenu.tscn").instance()

func _ready():
	$CanvasLayer/HUD.hide()
	game_over.set_name("GameOver")
	main_menu.set_name("MainMenu")
	
	game_over.get_node("Restart").connect("pressed", self, "restart_game")
	game_over.get_node("Back").connect("pressed", self, "show_main_menu")
	main_menu.get_node("Start").connect("pressed", self, "init_game")
#	main_menu.get_node("Exit").connect("Quit", OS, "exit_code")
	show_main_menu()
	
func show_main_menu():
	$CanvasLayer/HUD.hide()
	if $Menus.get_children():
		$Menus.call_deferred("remove_child", $Menus.get_children()[0])
	$Menus.call_deferred("add_child", main_menu)
	
func init_game():
	$CanvasLayer/HUD.show()
	var nb_children = $Menus.get_child_count()
	for i in range(nb_children):
		$Menus.call_deferred("remove_child", $Menus.get_children()[nb_children - i - 1])
	var map = map_scene.instance()
	map.set_name("Map")
	
	var camera = Camera2D.new()
	camera.make_current()
	camera.set_name("Camera")
	global.current_camera = camera
	camera.set_zoom(Vector2(2.1, 2.1))
	camera.set_anchor_mode(Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT)
	map.add_child(camera)
	
	add_child(map)
	$EnemisWavesTimer.start()
	
	self.get_node("BlizzardStreamPlayer").volume_db = -100.0
	
	var hud = self.get_node("CanvasLayer/HUD")
	var socket = self.get_node("Map/SocketSelectioner")
	hud.connect("turret_selected_signal", socket, "enable")
	
	$Map/Village.connect("change_nb_paysans_signal", $CanvasLayer/HUD, "update_peon_nb")
	$Map/Village.connect("change_nb_max_paysans_signal", $CanvasLayer/HUD, "update_peon_nb_max")
	$Map/Village.connect("change_nb_caillasse_signal", $CanvasLayer/HUD, "update_rock_nb")
	$Map/Village.connect("game_over_signal", self, "_on_Map_game_over_signal")
	$Map.connect("wave_enemis_finished_signal", self, "_on_Map_wave_enemis_finished_signal")

	$Map/Village.increase_max_paysans(20)
	$Map/Village.add_paysan(1)

func _process(delta):
		update_volume_of("BlizzardStreamPlayer", 50*delta)
	

func update_volume_of(var stream_name, var delta) :
	var volume_db = self.get_node(stream_name).volume_db
	var n_volume = volume_db
	if play_theme[stream_name] :
		if n_volume < 0.0 :
			n_volume += delta
			if n_volume > 0.0 :
				n_volume = 0.0
	else :
		if n_volume > -100.0 :
			n_volume -= delta
			if n_volume < -100.0 :
				n_volume = -100.0
	if n_volume != volume_db :
		self.get_node(stream_name).volume_db = n_volume

func _on_EnemisWavesTimer_timeout():
	$Map.spawn_enemis()

func _on_Map_wave_enemis_finished_signal():
	$Map/Village.add_paysan($Map.enemis_waves.front().get_nb_paysans())
	$EnemisWavesTimer.start()
	$Map.enemis_waves.pop_front()

func on_blizzard():
	self.play_theme["BlizzardStreamPlayer"] = true

func on_end_blizzard():
	self.play_theme["BlizzardStreamPlayer"] = false

func _on_Map_game_over_signal():
	$CanvasLayer/HUD.hide()
#	$Camera2D.dis
	remove_child($Map)
	$Menus.add_child(game_over)
	
func restart_game():
	$Menus.call_deferred("remove_child", $Menus/GameOver)
	init_game()
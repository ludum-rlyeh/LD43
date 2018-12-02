extends Node2D

var SPEED = 10

func _ready():
	var hud = self.get_node("CanvasLayer/HUD")
	var socket = self.get_node("Map/SocketSelectioner")
	hud.connect("turret_selected_signal", socket, "enable")
	
	$Map/Village.connect("change_nb_paysans_signal", $CanvasLayer/HUD, "update_peon_nb")
	$Map/Village.connect("change_nb_max_paysans_signal", $CanvasLayer/HUD, "update_peon_nb_max")
	$Map/Village.connect("change_nb_caillasse_signal", $CanvasLayer/HUD, "update_rock_nb")

	$Map/Village.increase_max_paysans(20)
	$Map/Village.add_paysan(1)
	
	global.current_camera = $Camera2D

func _process(delta):
	var position = $Camera2D.get_position()
	if Input.is_action_pressed("ui_right"):
		position = Vector2(position.x + SPEED, position.y)
	elif Input.is_action_pressed("ui_left"):
		position = Vector2(position.x - SPEED, position.y)
	elif Input.is_action_pressed("ui_up"):
		position = Vector2(position.x, position.y - SPEED)
	elif Input.is_action_pressed("ui_down"):
		position = Vector2(position.x, position.y + SPEED)
	elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
		print("mouse")
	$Camera2D.set_position(position)

func _on_EnemisWavesTimer_timeout():
	var nb_enemis = 1
#	var nb_enemis = rand_range(10, 20)
	$Map.spawn_enemis(nb_enemis, global.ENEMI_BASE)

func _on_Map_wave_enemis_finished_signal():
	$EnemisWavesTimer.start()

func _on_game_over_signal():
	print("game over")

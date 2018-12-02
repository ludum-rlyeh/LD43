extends Node2D

var SPEED = 10
var zoom_scroll = Vector2(0.05, 0.05)
var clamp_zoom = [Vector2(1,1), Vector2(2.2,2.2)]

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
	elif Input.is_action_pressed("zoom_camera_avant"):
		$Camera2D.set_zoom(Vector2(clamp($Camera2D.zoom.x + zoom_scroll.x, self.clamp_zoom[0].x, self.clamp_zoom[1].x), clamp($Camera2D.zoom.y + zoom_scroll.y, self.clamp_zoom[0].y, self.clamp_zoom[1].y)))
	elif Input.is_action_pressed("zoom_camera_arriere"):
		$Camera2D.set_zoom(Vector2(clamp($Camera2D.zoom.x - zoom_scroll.x, self.clamp_zoom[0].x, self.clamp_zoom[1].x), clamp($Camera2D.zoom.y - zoom_scroll.y, self.clamp_zoom[0].y, self.clamp_zoom[1].y)))
	$Camera2D.set_position(position)

func _on_EnemisWavesTimer_timeout():
	$Map.spawn_enemis()

func _on_Map_wave_enemis_finished_signal():
	$Map/Village.add_paysan($Map.enemis_waves.front().get_nb_paysans())
	$EnemisWavesTimer.start()
	$Map.enemis_waves.pop_front()

func _on_game_over_signal():
	print("game over")

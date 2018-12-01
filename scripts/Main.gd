extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var hud = self.get_node("CanvasLayer/HUD")
	var socket = self.get_node("Map/SocketSelectioner")
	hud.connect("turret_selected_signal", socket, "enable")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_EnemisWavesTimer_timeout():
	var nb_enemis = 10 #rand_range(10, 20)
	$Map.spawn_enemis(nb_enemis, global.ENEMI_BASE)


func _on_Map_wave_enemis_finished_signal():
	$EnemisWavesTimer.start()

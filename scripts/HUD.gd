extends Control

signal turret_selected_signal

func _ready():
	pass

func update_peon_nb(var nb) :
	var peon_nb = String(nb / 1000) + String((nb % 1000) / 100) + String((nb % 100) / 10) + String(nb % 10);
	self.get_node("VBoxContainer/peons/peon_nb").text = peon_nb


func update_rock_nb(var nb) :
	var rock_nb = String(nb / 1000) + String((nb % 1000) / 100) + String((nb % 100) / 10) + String(nb % 10);
	self.get_node("VBoxContainer/rocks/rock_nb").text = rock_nb

func _on_base_turret_gui_input(ev):
	if (ev is InputEventMouseButton and ev.is_pressed()) :
		var turret = load("res://scenes/Turret.tscn").instance()
		emit_signal("turret_selected_signal", turret)
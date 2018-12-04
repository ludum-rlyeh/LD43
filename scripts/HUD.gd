extends Control

signal turret_selected_signal

var show_wave = false

func _process(delta):
	var time_left = get_parent().get_parent().get_node("EnemisWavesTimer").time_left
	if time_left == 0 and show_wave :
		var main = get_parent().get_parent()
		if main.has_node("Map") :
			var map = main.get_node("Map")
			var nb_waves = map.nb_waves
			var waves_no = nb_waves - map.enemis_waves.size() + 1
			self.get_node("Timer").text = String(waves_no) + " / " + String(nb_waves)
	else :
		if show_wave :
			show_wave = false
		update_timer_label(time_left)

func update_timer_label(var time) :
	var time_label = String(int(time+1))
	if time == 0 : 
		time_label = "0"
		show_wave = true
	self.get_node("Timer").text = time_label

func update_peon_nb(var nb) :
	self.get_node("peon_nb").text = String(nb)
	
func update_peon_nb_max(var nb) :
	self.get_node("peon_nb_max").text = String(nb)

func update_rock_nb(var nb) :
	self.get_node("rock_nb").text = String(nb)

func _on_base_turret_gui_input(ev):
	if (ev is InputEventMouseButton and ev.is_pressed()) :
		var turret = load("res://scenes/Turret.tscn").instance()
		emit_signal("turret_selected_signal", turret)
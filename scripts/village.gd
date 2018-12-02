extends Node

signal change_nb_paysans_signal
signal change_nb_max_paysans_signal
signal change_nb_caillasse_signal
signal game_over_signal
signal sacrifice_signal

var caillasse = 0
var nb_paysans = 100
var base_production = 1
var farms = []

export (int) var max_paysans
export (int) var time_init

var timer

func _ready():
	var timer = $Timer
	timer.wait_time = self.time_init
	timer.connect("timeout", self, "production_caillasse")
	
	self.get_node("SacrificeMenu").hide()

func add_paysan(var nb):
	self.nb_paysans = min(self.nb_paysans + nb, self.max_paysans)
	if self.nb_paysans > 0:
		$Timer.wait_time = time_init / float(self.nb_paysans)
	emit_signal("change_nb_paysans_signal", self.nb_paysans)

func remove_paysans(var nb):
	self.nb_paysans = max(self.nb_paysans - nb, 0)
	if self.nb_paysans > 0:
		$Timer.wait_time = time_init / float(self.nb_paysans)
	else:
		emit_signal("game_over_signal")
	emit_signal("change_nb_paysans_signal", self.nb_paysans)

func production_caillasse():
	$Timer.wait_time = time_init
	print("ca produit")
	if self.nb_paysans > 0:
		self.caillasse += int(log(self.nb_paysans)*self.base_production)
	print("eeemmit")
	emit_signal("change_nb_caillasse_signal", self.caillasse)
	
func decrease_caillasse(var nb):
	self.caillasse = max(self.caillasse - nb, 0)
	emit_signal("change_nb_caillasse_signal", self.caillasse)

func increase_max_paysans(var nb):
	self.max_paysans += nb
	emit_signal("change_nb_max_paysans_signal", self.max_paysans)

func decrease_max_paysans(var nb):
	self.max_paysans -= nb
	emit_signal("change_nb_max_paysans_signal", self.max_paysans)

func add_farm(var capacity):
	self.farms.append(capacity)
	increase_max_paysans(capacity)

func remove_farm(var index):
	if index > 0 && index < self.farms.size():
		var farm = self.farms[index]
		decrease_max_paysans(farm)
		self.farms.remove(index)

func _on_Village_gui_input(ev):
	if ev is InputEventMouseButton and ev.is_pressed() :
		var menu = self.get_node("SacrificeMenu")
		if not menu.is_visible_in_tree() :
			menu.show()
		else :
			menu.hide()

func _on_Thorn_pressed():
	var nb_sacrifice = int(self.get_node("SacrificeMenu/Thorn/nb_sacrifice").text)
	if nb_sacrifice < nb_paysans :
		emit_signal("sacrifice_signal", global.SACRIFICE_TYPE.THORNS)
		remove_paysans(nb_sacrifice)
		self.get_node("SacrificeMenu").hide()

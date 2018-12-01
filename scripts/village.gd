extends Node

var caillasse
var nb_paysans

var timer

func _ready():
	self.timer = Timer.new()
	self.timer.wait_time = 1
	timer.connect("timeout", self, "production_caillasse")
	
func add_paysan(var nb):
	pass

func production_caillasse():
	self.caillasse += 1
	
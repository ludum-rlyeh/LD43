extends Node

var caillasse = 0
var nb_paysans = 1
var farms = [10]
export (int) var max_paysans
export (int) var time_init

var timer

func _ready():
	var timer = $Timer
	timer.wait_time = self.time_init
	timer.connect("timeout", self, "production_caillasse")
	add_paysan(1)
	
func _process(delta):
	print(self.caillasse)
	
func add_paysan(var nb):
	self.nb_paysans = max(self.nb_paysans + nb, self.max_paysans)
	if self.nb_paysans > 0:
		$Timer.wait_time = time_init / float(self.nb_paysans)
		
func remove_paysans(var nb):
	self.nb_paysans = min(self.nb_paysans - nb, 0)
	if self.nb_paysans > 0:
		$Timer.wait_time = time_init / float(self.nb_paysans)

func production_caillasse():
	self.caillasse += 1
	
func increase_max_paysans(var nb):
	self.max_paysans += nb
	
func decrease_max_paysans(var nb):
	self.max_paysans -= nb
	
func add_farm(var capacity):
	self.farms.append(capacity)
	increase_max_paysans(capacity)
	
func remove_farm(var index):
	if index > 0 && index < self.farms.size():
		var farm = self.farms[index]
		decrease_max_paysans(farm)
		self.farms.remove(index)
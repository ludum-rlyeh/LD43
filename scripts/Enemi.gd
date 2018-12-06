extends Node2D

signal finish_path_signal
signal enemi_died_signal

export (float) var speed
export (float) var SEUIL

var velocity_norm = Vector2(0,0)
var path = []
var nb_paysans_to_kill = 10
var life = 175
var max_speed
var freeze_material = preload("res://assets/materials/freeze.material")

func _ready(): 
	self.max_speed = self.speed
	

func _process(delta):
	self.position += self.velocity_norm * self.speed * delta
	update_velocity()
	if self.velocity_norm.dot(Vector2(1, 0)) >= 0:
		$Sprite.flip_h = 1
		$Sprite.offset = Vector2(20, 0)
		pass
	else :
		$Sprite.flip_h = 0
		$Sprite.offset = Vector2(-20, 0)

func set_path(var path):
	self.path = path.duplicate()
	self.position = self.path.front()  * global.CELL_SIZE

func set_speed(var value):
	self.speed = value
	self.max_speed = self.speed

func update_velocity():
	if !self.path.empty():
		var point = self.path.front() * global.CELL_SIZE
		var distance = (get_position() - point).length()
		if distance < SEUIL:
			self.path.pop_front()
			update_velocity()
		self.velocity_norm = (point - get_position()).normalized()
		if self.path.empty():
			emit_signal("finish_path_signal", self)
	else:
		self.velocity_norm = Vector2(0,0)

func take_damages(power):
	# print("Aouch :" + str(self) + " life:" + str(self.life))
	self.life -= power
	if(self.life <= 0):
		die()
	
func die():
	emit_signal("enemi_died_signal", self)
	var area = self.get_node("Collision")
	var turrets = area.get_overlapping_areas()
	for turret in turrets:
		turret.get_parent().ennemi_die(self)
	self.get_parent().call_deferred("remove_child", self)
	self.call_deferred("queue_free")

func on_lightning() :
	var time = 0.3
	$Lightning.init(time)
	$Lightning.start()
	var timer = get_tree().create_timer(time, false)
	timer.connect("timeout", self, "end_lightning")

func end_lightning() :
	set_modulate(Color(0,0,0,1))
	$Sprite.stop()
	set_process(false)
	var timer = get_tree().create_timer(0.5, false)
	timer.connect("timeout", self, "die")
	get_node("../..").get_node("ColorRect").hide()

func slow_down(var delta, var time) :
	var timer = get_tree().create_timer(time,false)
	timer.connect("timeout", self, "unslow", [delta])
	self.speed *= delta
	if !$Sprite.get_material():
		$Sprite.set_material(freeze_material)

func unslow(var delta) :
	self.speed /= delta
	if self.speed >= self.max_speed - 1.0:
		$Sprite.set_material(null)

func stuned() :
	self.speed = 0
	$PlantAnimation.play("plante")
	$PlantBGAnimation.play("plante")

func unstuned() :
	self.speed = self.max_speed
	$PlantAnimation.play("plante2")
	$PlantBGAnimation.play("plante2")
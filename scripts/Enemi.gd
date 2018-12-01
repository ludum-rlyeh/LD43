extends Node2D

signal finish_path_signal

export (float) var speed
export (float) var SEUIL

var dead = false
var velocity_norm = Vector2(0,0)
var path = []

var life = 100

func _ready():
	self.scale = Vector2(0.8, 0.8)

func _process(delta):
	self.position += self.velocity_norm * self.speed * delta
	update_velocity()

func set_path(var path):
	self.path = path.duplicate()
	self.position = self.path.front()  * global.CELL_SIZE

func set_speed(var value):
	self.speed = value

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
	if(0 >= self.life):
		var area = self.get_node("Collision")
		var turrets = area.get_overlapping_areas()
		for turret in turrets:
			turret.get_parent().ennemi_die(self)
		self.dead = true
		self.get_parent().call_deferred("remove_child", self)
		self.call_deferred("queue_free")

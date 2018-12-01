extends Node2D

signal finish_path_signal

export (float) var speed
export (float) var SEUIL
var velocity_norm = Vector2(0,0)
var path = []

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
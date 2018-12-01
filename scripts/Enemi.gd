extends Node2D

export (float) var speed
export (float) var SEUIL
var velocity_norm = Vector2(0,0)
var path = []

func _process(delta):
	self.position += self.velocity_norm * self.speed * delta
#	print(position)
	update_velocity(delta)
#	print("enemi ", get_name(), " ", self.velocity_norm, " ", self.speed)
	
func set_path(var path):
	self.path = path.duplicate()
	self.position = self.path.front()  * global.CELL_SIZE
	
func set_speed(var value):
	self.speed = value
	
func update_velocity(var delta):
	if !self.path.empty():
		var point = self.path.front() * global.CELL_SIZE
		var distance = (get_position() - point).length()
		if distance < SEUIL:
			self.path.pop_front()
			update_velocity(delta)
			return true
		self.velocity_norm = (point - get_position()).normalized()
	else:
		self.velocity_norm = Vector2(0,0)
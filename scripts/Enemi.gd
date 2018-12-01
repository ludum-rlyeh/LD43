extends Node2D

export (float) var SPEED
export (float) var SEUIL
var velocity_norm = Vector2(0,0)
var line = []

func _ready():
	set_line([Vector2(100,0), Vector2(100,100), Vector2(200,200)])

func _process(delta):
	move_and_slide(self.velocity_norm * SPEED)
	
	update_velocity(delta)
	
func set_line(var line):
	self.line = line
	
func update_velocity(var delta):
	if !self.line.empty():
		var point = self.line.front()
		var distance = (get_position() - point).length()
		if distance < SEUIL:
			self.line.pop_front()
			update_velocity(delta)
			return true
		self.velocity_norm = (point - get_position()).normalized()
	else:
		self.velocity_norm = Vector2(0,0)
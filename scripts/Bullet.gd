extends Node2D

var speed = 1000
var target_pos

func _ready():
	pass

func _process(delta):
	self.position += target_pos.normalized() * self.speed * delta
	if(Vector2(0,0).distance_to(target_pos) < Vector2(0,0).distance_to(self.position)):
		self.get_parent().call_deferred("remove_child", self)
		self.call_deferred("queue_free")

func throw(pos):
	target_pos = pos
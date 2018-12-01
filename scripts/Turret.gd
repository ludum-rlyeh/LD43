extends Node2D

# Attaque range in px ?
var attaque_range = 35

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.get_node("Area2D/CollisionShape2D").scale = Vector2(attaque_range, attaque_range)
	pass


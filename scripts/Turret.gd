extends Node2D

# Attaque range in px ?
var attaque_range = 35

onready var collision_range = self.get_node("Area2D/CollisionShape2D")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	collision_range.scale = Vector2(attaque_range, attaque_range)
	pass
	
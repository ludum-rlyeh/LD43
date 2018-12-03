extends "res://scripts/Turret.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var capacity = 70

func _ready():
	self.max_targets = 0
	self.attaque_range = 0
	self.type = global.TOWER_TYPE.FARM
	
	collision_range = null
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

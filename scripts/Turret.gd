extends Node2D

# Attaque range in px ?

var attaque_range = 35
var max_targets = 1
var power = 10
var attaque_speed = 0.2
var cd = 0

var ennemy_on_range = []
var targets = []

onready var collision_range = self.get_node("Area2D/CollisionShape2D")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	collision_range.scale = Vector2(attaque_range, attaque_range)
	pass
	
func _process(delta):
	select_target()
	if(0 >= cd):
		apply_damages()
		cd = self.attaque_speed
	else:
		cd -= delta
	pass
	
func apply_damages():
	for target in targets:
		target.take_damages(self.power)

func ennemi_die(cadaver):
	if targets.has(cadaver):
		targets.remove(targets.find(cadaver))
		pass
	if ennemy_on_range.has(cadaver):
		ennemy_on_range.remove(ennemy_on_range.find(cadaver))
		pass
		
func select_target():
	var nb_ranged_ennemy = len(ennemy_on_range)
	var nb_targets = len(targets)
	if( (0 < nb_ranged_ennemy) &&
	    (nb_targets < self.max_targets) &&
	    (nb_targets < nb_ranged_ennemy)):
	
		var t = rand_range(0, nb_ranged_ennemy - 1)
		while(!targets.has(ennemy_on_range[t])):
			targets.append(ennemy_on_range[t])
			t = rand_range(0, nb_ranged_ennemy - 1)

func _on_Area2D_area_entered(area):
	ennemy_on_range.append(area.get_parent())
	pass # replace with function body

func _on_Area2D_area_exited(area):
	var unit = area.get_parent()
	safe_remove(ennemy_on_range, unit)
	safe_remove(targets, unit)
	pass # replace with function body

func safe_remove(collection, item):
	var idx = collection.find(item)
	if idx != -1:
		collection.remove(idx)
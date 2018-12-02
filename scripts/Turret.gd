extends Node2D

# Attaque range in px ?

var attaque_range = 190
var max_targets = 1
var power = 5
var attaque_speed = 0.2
var cd = 0
var type = global.TOWER_TYPE.TURRET
var ennemy_on_range = []
var targets = []

var show_range = false

onready var collision_range = self.get_node("Area2D/CollisionShape2D")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	if collision_range != null:
		var shape = CircleShape2D.new()
		shape.set_radius(attaque_range)
		collision_range.set_shape(shape)
		
		$Area2D.connect("area_entered", self, "_on_Area2D_area_entered")
		$Area2D.connect("area_exited", self, "_on_Area2D_area_exited")



func draw_range():
	draw_empty_circle(Vector2(0,0), Vector2(0, attaque_range), Color(255, 255, 255), 0.5)
	draw_circle(Vector2(0,0), attaque_range, Color(1, 1, 1, 0.2))
	
func _draw():
	if self.show_range:
		draw_range()

func draw_empty_circle(circle_center,  circle_radius,  color, resolution):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)

func _process(delta):
	select_target()
	if(0 >= cd):
		apply_damages()
		cd = self.attaque_speed
	else:
		cd -= delta

func set_phantom(can_buy):
	if !can_buy:
		$Sprite.modulate.r = 100
	else:
		$Sprite.modulate.r = 0
	$Sprite.modulate.a = 0.7
	show_range = true
	max_targets = 0
	
	self.update()

func apply_damages():
	for target in targets:
		target.take_damages(self.power)
		throw_bullet(target.position)

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

func _on_MouseDetector_mouse_entered():
	print("caca in")
	self.show_range = true
	self.call_deferred("update")
	pass # replace with function body

func _on_MouseDetector_mouse_exited():
	print("caca out")
	self.show_range = false
	self.call_deferred("update")
	pass # replace with function body

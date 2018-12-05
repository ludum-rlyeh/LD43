extends "res://scripts/Turret.gd"

var cannonball_bullet_scene = preload("res://scenes/ball_bullet.tscn")

var radius = 100

func _process(delta):
	._process(delta)

func _ready() :
	._ready()
	self.type = global.TOWER_TYPE.CANON
	self.power = 25
	self.attaque_range = 250
	self.attaque_speed = 5.0

func shoot(var enemi_position):
	var angle = Vector2(0, -1).angle_to(enemi_position.normalized())
	var cannonball_bullet = cannonball_bullet_scene.instance()
	cannonball_bullet.set_position($Position2D.position)
	cannonball_bullet.target_pos = enemi_position
	$Canon.set_rotation(angle)
	add_child(cannonball_bullet)

func apply_damages():
	for target in targets:
		shoot(target.position - self.global_position)
	
func remove_bullet(var bullet):
	get_node("../..").damage_in_zone(bullet.global_position, self.radius, self.power)
	get_parent().call_deferred("remove_child", bullet)
	bullet.call_deferred("queue_free")

func _on_MouseDetector_mouse_entered():
	._on_MouseDetector_mouse_entered()
	pass # replace with function body

func _on_MouseDetector_mouse_exited():
	._on_MouseDetector_mouse_exited()
	pass # replace with function body

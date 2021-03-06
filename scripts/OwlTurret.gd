extends "res://scripts/Turret.gd"

var magic_ball_scene = preload("res://scenes/magic_bullet.tscn")

func _process(delta):
	._process(delta)

func _ready() :
	._ready()
	self.power = 0.5
	self.attaque_speed = 2.0
	self.type = global.TOWER_TYPE.WIZARD

func shoot(var enemi_position):
	var angle = Vector2(0, -1).angle_to(enemi_position.normalized())
	
	var magic_ball = magic_ball_scene.instance()
	magic_ball.set_position($Position2D.position)
	magic_ball.target_pos = enemi_position
	add_child(magic_ball)
	
func apply_damages():
	for target in targets:
		target.slow_down(self.power, self.attaque_speed)
		shoot(target.position - self.global_position)
	
func remove_bullet(var bullet):
	call_deferred("remove_child", bullet)
	bullet.call_deferred("queue_free")

func _on_MouseDetector_mouse_entered():
	._on_MouseDetector_mouse_entered()
	pass # replace with function body

func _on_MouseDetector_mouse_exited():
	._on_MouseDetector_mouse_exited()
	pass # replace with function body

extends "res://scripts/Turret.gd"

var arrow_scene = preload("res://scenes/arrow.tscn")

func _process(delta):
	._process(delta)

func shoot(var enemi_position):
	var angle = Vector2(0, -1).angle_to(enemi_position.normalized())
	$Arbalete.set_rotation(angle)
	
	var arrow = arrow_scene.instance()
	arrow.set_position($Position2D.position)
	arrow.set_rotation(angle)
	arrow.set_scale(Vector2(0.2,0.2))
	arrow.target_pos = enemi_position
	add_child(arrow)
	
func apply_damages():
	for target in targets:
		target.take_damages(self.power)
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

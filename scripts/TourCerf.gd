extends "res://scripts/Turret.gd"

var arrow_scene = preload("res://scenes/arrow.tscn")

func shoot(var vec):
	var angle = Vector2(0, -1).normalized().angle_to(vec)
	$Arbalete.set_rotation(angle)
	
	var arrow = arrow_scene.instance()
	arrow.set_position($Position2D.position)
	var scale = Vector2(0.4, 0.4)
	arrow.set_scale(scale)
	arrow.set_rotation(angle)
	arrow.target_pos = vec
	add_child(arrow)
	
func apply_damages():
	for target in targets:
		target.take_damages(self.power)
		shoot(target.position)
	
func remove_bullet(var bullet):
	call_deferred("remove_child", bullet)
	bullet.call_deferred("queue_free")
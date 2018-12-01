extends Node2D

signal clicked_on_cell_signal

var object

func ready():
	disable()

func enable(var object):
	set_visible(true)
	$SpriteGhost.set_texture(object.get_node("Sprite").get_texture())
	print($SpriteGhost.get_texture())
	$SpriteGhost.set_modulate(Color(1,1,1,0.5))
	
func disable():
	set_visible(false)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		move(global.position_to_index(event.position + Vector2(global.CELL_SIZE/2, global.CELL_SIZE/2), global.CELL_SIZE))
	elif event is InputEventMouseButton && event.is_pressed():
		click_on(global.position_to_index(event.position + Vector2(global.CELL_SIZE/2, global.CELL_SIZE/2), global.CELL_SIZE))
		
func move(var position_index):
	self.position = global.index_to_position(position_index, global.CELL_SIZE)
	
func click_on(var index):
	emit_signal("clicked_on_cell_signal", index, self.object)
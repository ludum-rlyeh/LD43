extends Node2D

signal clicked_on_cell_signal

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		move(global.position_to_index(event.position, global.CELL_SIZE))
	elif event is InputEventMouseButton && event.is_pressed():
		click_on(global.position_to_index(event.position, global.CELL_SIZE))
		
func move(var position_index):
	self.position = global.index_to_position(position_index, global.CELL_SIZE)
	
func click_on(var index):
	emit_signal("clicked_on_cell_signal", index)
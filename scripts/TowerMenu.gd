extends Control

signal asking_batiment_creation
signal print_phantom
signal hide_phantom

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func string_to_gbl_enum(type):
	if(type == "Farm"):
		return global.TOWER_TYPE.FARM
	if(type == "Turret"):
		return global.TOWER_TYPE.TURRET
	if(type == "Wizard"):
		return global.TOWER_TYPE.WIZARD

func _on_Turret_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.TURRET)
	self.hide()

func _on_Wizard_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.WIZARD)
	self.hide()

func _on_Canon_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.CANON)
	self.hide()

func _on_Farm_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.FARM)
	self.hide()

func _on_Button_mouse_entered(type):
	emit_signal("print_phantom", string_to_gbl_enum(type))

func _on_Button_mouse_exited(type):
	emit_signal("hide_phantom")
	pass # replace with function body

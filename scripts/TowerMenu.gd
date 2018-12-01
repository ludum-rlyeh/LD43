extends Control

signal asking_tower_creation

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_Turret_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.TURRET)

func _on_Wizard_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.WIZARD)

func _on_Canon_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.CANON)

func _on_Farm_pressed():
	emit_signal("asking_batiment_creation", global.TOWER_TYPE.FARM)

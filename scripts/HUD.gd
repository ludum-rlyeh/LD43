extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func update_peon_nb(var nb) :
	var peon_nb = String(nb / 1000) + String((nb % 1000) / 100) + String((nb % 100) / 10) + String(nb % 10);
	self.get_node("peons/peon_nb").text = peon_nb

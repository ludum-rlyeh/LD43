extends "res://scripts/Map.gd"

func _ready():
	self.paths = [
		[
	Vector2(0,9),
	Vector2(3,9),
	Vector2(3,14),
	Vector2(6,14),
	Vector2(6,5),
	Vector2(10,5),
	Vector2(10,15),
	Vector2(16,15),
	Vector2(16,12) 
		],
		[
	Vector2(33,10),
	Vector2(27,10),
	Vector2(27,5),
	Vector2(23,5),
	Vector2(23,10),
	Vector2(20,10),
	Vector2(20,5),
	Vector2(16,5),
	Vector2(16,8) 
		]
	]
	var enemis_waves_script = load("res://scripts/EnemisWaves.gd")
	
	self.enemis_waves = [
		#param 1 : nb base enemis, param2 : nb boss enemis, param3 : cadence de spawn entre enemis
		enemis_waves_script.new(10,  1, 1.5),
		enemis_waves_script.new(10, 0, 1.5),
		enemis_waves_script.new(15, 1, 1.5),
		enemis_waves_script.new(25, 2, 1),
		enemis_waves_script.new(30, 3, 1),
		enemis_waves_script.new(40, 5, 1),
		enemis_waves_script.new(50, 6, 1),
		enemis_waves_script.new(70, 6, 1),
		enemis_waves_script.new(100, 10, 0.8)
	]
	self.nb_waves = enemis_waves.size()

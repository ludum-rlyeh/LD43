extends Node

var nb_enemis_de_base = 0
var nb_enemis_boss = 0
var cadence_spawn = 1

func _init(var nb_enemis_de_base, var nb_enemis_boss, var cadence):
	self.nb_enemis_de_base = nb_enemis_de_base
	self.nb_enemis_boss = nb_enemis_boss
	self.cadence_spawn = cadence

func get_nb_paysans():
	return nb_enemis_de_base / 2 + nb_enemis_boss
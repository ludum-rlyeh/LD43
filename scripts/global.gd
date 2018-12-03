extends Node

const CELL_SIZE = 64

enum TILE_TYPE{PATH_TILE, SOCKET_TILE, SOCKET_BUSY}
enum ENEMI_TYPE{ENEMI_BASE}

enum TOWER_TYPE{TURRET, WIZARD, CANON, FARM}
enum SACRIFICE_TYPE{THORNS, LIGHTNING, METEORS, BLIZZARD}

var TOWER_PRICES = { 
						TOWER_TYPE.TURRET: 25,
						TOWER_TYPE.WIZARD : 50,
						TOWER_TYPE.CANON : 70,
						TOWER_TYPE.FARM: 100
					}

var current_camera

func position_to_index(var position, var offset):
	return Vector2(int(position.x / offset), int(position.y / offset))
	
func index_to_position(var index, var offset):
	return index * offset
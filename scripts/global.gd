extends Node

const CELL_SIZE = 64

enum TILE_TYPE{PATH_TILE, SOCKET_TILE, SOCKET_BUSY}
enum ENEMI_TYPE{ENEMI_BASE}

func position_to_index(var position, var offset):
	return Vector2(int(position.x / offset), int(position.y / offset))
	
func index_to_position(var index, var offset):
	return index * offset
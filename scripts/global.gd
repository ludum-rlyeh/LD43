extends Node

const CELL_SIZE = 64

enum TILE_TYPE{PATH_TILE, SOCKET_TILE}

func position_to_index(var position, var offset):
	return Vector2(int(position.x / offset), int(position.y / offset))
	
func index_to_position(var index, var offset):
	return index * offset
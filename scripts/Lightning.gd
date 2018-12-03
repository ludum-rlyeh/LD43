extends Node2D

var init_time
var time
var h = 1000

func _ready():
	set_process(false)

func init(var time):
	self.init_time = time
	self.time = 0
	
func start():
	set_process(true)

func _process(delta):
	var size = $Sprite.region_rect.size
	self.time += delta
	var h_trans = h * (time/init_time)
	$Sprite.region_rect.size = Vector2(size.x, h_trans)
	if self.time >= init_time :
		$Sprite.hide()
		set_process(false)
	
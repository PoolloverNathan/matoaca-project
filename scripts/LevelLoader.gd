extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level: TileMap
var levelNum = 1
signal loaded_level(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	loadLevel()

func loadLevel():
	var res = load("res://levels/level" + levelNum + ".tscn")
	var scn = res.instance()
	if level:
		self.remove_child(level)
	self.add_child(scn)
	
	level = scn
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

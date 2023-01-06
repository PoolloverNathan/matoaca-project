extends Node2D

onready var player := $Player
onready var map := $TileMap
var killedLasers = false
export var levelId: String
export var worldMap: PackedScene

func killLasers():
	killedLasers = true
	map.remove_child(map.get_node("Lasers"))
func isLasersKilled():
	return killedLasers
func reload():
	BlackFade.fadeout()
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	BlackFade.fadein()
func win():
	var save: Savegame = PlayerService.getSave()
	save.set(levelId + "_completed", true)
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(worldMap)
func _ready():
	$Player.connect("reload", self, "reload")

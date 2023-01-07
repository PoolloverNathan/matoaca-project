extends Node2D

func reload():
	BlackFade.fadeout()
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	BlackFade.fadein()
func _ready():
	$Player.connect("reload", self, "reload")
	$Player.transform.origin = PlayerService.getSave().spawnAt

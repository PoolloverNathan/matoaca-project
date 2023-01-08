extends Node2D

func reload():
	BlackFade.fadeout()
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	BlackFade.fadein()
func _ready():
	PlayerService.active = true
	PlayerService.loadSave()
	$Player.connect("reload", self, "reload")
	$Player.global_position = PlayerService.getSave().spawn_at

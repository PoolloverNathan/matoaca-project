extends Node2D
export var isRootLevel = false

func reload():
	# BlackFade.fadeout(self, "finish_reload")
	finish_reload()
func finish_reload():
	get_tree().reload_current_scene()
	BlackFade.fadein()
func _ready():
	PlayerService.active = true
	PlayerService.loadSave()
	if isRootLevel:
		$Player.global_position = PlayerService.getSave().spawn_at
	$Player.connect("reload", self, "reload")
	for child in $TileMap.get_children():
		if child is TileMap:
			child.modulate = Color(1, 1, 1)
func add_child(node: Node, legible_unique_name = false):
	.add_child(node, legible_unique_name)
	if node is TileMap:
		node.modulate = Color(1, 1, 1)

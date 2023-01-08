extends ToolButton

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	disabled = not PlayerService.canPopScene()

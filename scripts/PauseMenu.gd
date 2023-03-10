extends Node2D

func pause():
	get_tree().paused = true
	show()
	print("--- OPENING PAUSE MENU ---")

var pauseLastFrame = false
func _process(_delta):
	if Input.get_action_strength("pause"):
		if not pauseLastFrame:
			pauseLastFrame = true
			if get_tree().paused:
				resume()
			else:
				pause()
	else:
		pauseLastFrame = false
func _ready():
	resume()

func resume():
	print("--- CLOSING PAUSE MENU ---")
	hide()
	get_tree().paused = false

func options(): pass

func progress(): pass

func saves(): pass

func exit_level():
	if PlayerService.canPopScene():
		PlayerService.popScene()
		resume()
	else:
		get_tree().quit() # unreachable

func quit():
	BlackFade.fadeout()
	get_tree().quit(0)
	get_tree().root.free() # crash in case quit doesn't work for some reason

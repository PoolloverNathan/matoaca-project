extends Control

func quit():
	BlackFade.fadeout()
	get_tree().quit(0)
	get_tree().root.free() # crash in case quit doesn't work for some reason

extends ToolButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Did you know that it is actually against Apple's rules to have a quit button in your app?
	if OS.get_name() == "iOS":
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player := $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	player.play("fadein")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func fadein(wait = true):
	player.play("fadein")
	if wait:
		_wait()
	
func fadeout(wait = true):
	player.play_backwards("fadein")
	if wait:
		_wait()

func _wait():
	var timer := Timer.new()
	timer.wait_time = 1
	timer.start()
	yield(timer, "timeout")

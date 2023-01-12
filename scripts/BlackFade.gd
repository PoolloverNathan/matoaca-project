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

func fadein(instance: Object = null, fun = ""):
	player.play("fadein")
	if instance:
		_wait(instance, fun)

func fadeout(instance: Object = null, fun = ""):
	player.play_backwards("fadein")
	if instance:
		_wait(instance, fun)

func _wait(instance: Object, fun = ""):
	# var timer := Timer.new()
	# timer.wait_time = 1
	# add_child(timer)
	# timer.start()
	# yield(timer, "timeout")
	# timer.queue_free()
	# OS.delay_msec(1000)
	# yield(player, "animation_finished")
	# yield(get_tree().create_timer(1), "timeout")
	get_tree().create_timer(1).connect("timeout", instance, fun)

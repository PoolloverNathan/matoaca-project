tool class_name Gem extends Node2D

## The type of gem that this is.
enum TYPE {
	DECORATIVE,
	## A yellow gem that will give the player another level of shield.
	SHIELD,
	## A blue gem that immediately saves your save file.
	SAVE_POINT,
	## A red gem that starts a secret level. It can be exited through the pause menu.
	SUBLEVEL,
	## A green gem that will be saved in the save file.
	COLLECTIBLE,
	BROWN,
	BLACK,
	TAN,
	## An orange gem whose collection ends the current secret level. Its collection will also be saved in the save file. 
	ORANGE,
	## A pink gem that starts a secret level. It cannot be exited through the pause menu.
	PINK,
	## A purple gem that removes a layer. This will be tracked in the save file, and the layer will be removed on load.
	## target = the node to remove.
	PURPLE,
}

func h(r, g, b):
	if r > 1: r /= 255
	if g > 1: g /= 255
	if b > 1: b /= 255
	return Color(r, g, b)

var COLORMAP = {
	TYPE.DECORATIVE: h(135, 242, 255),
	TYPE.SHIELD: h(255, 246, 9),
	TYPE.SAVE_POINT: h(0, 63, 173),
	TYPE.SUBLEVEL: h(255, 33, 33),
	TYPE.COLLECTIBLE: h(120, 220, 82),
	TYPE.BROWN: h(145, 70, 61),
	TYPE.BLACK: h(0, 0, 0),
	TYPE.TAN: h(229, 205, 196),
	TYPE.ORANGE: h(255, 129, 53),
	TYPE.PINK: h(255, 147, 196),
	TYPE.PURPLE: h(142, 46, 196)
}

export(TYPE) var type
## The name of the gem, used for tracking the gem's collection status.
export(NodePath) var target = null
## The stage number of the gem, if it is a save point.
export var stageNumber = 0
onready var target_node = get_node(target) if target else null
export(PackedScene) var level

func _ready():
	if Engine.editor_hint:
		return
	PlayerService.connect("save_loaded", self, "_save_loaded")
func _save_loaded(save):
	if save.get(name):
		hit()

func get_color():
	return COLORMAP[type]

func hit():
	# if Engine.editor_hint:
	# 	return
	$Gem.mode = RigidBody2D.MODE_RIGID
	$Gem.apply_impulse(Vector2(0, 1), Vector2(5, -5))
	sideEffect(false)
func sideEffect(fromSave):
	var save = PlayerService.getSave()
	# if Engine.editor_hint:
	# 	return
	match type:
		TYPE.PURPLE:
			if target_node:
				target_node.queue_free()
				target = ""
		TYPE.SUBLEVEL:
			if not fromSave:
				PlayerService.pushScene(level, true)
		TYPE.PINK:
			if not fromSave:
				PlayerService.pushScene(level, false)
		TYPE.COLLECTIBLE, TYPE.ORANGE:
			if not fromSave: # don't waste time setting it
				save[name] = true
				PlayerService.save()
		TYPE.ORANGE:
			PlayerService.popScene()
		TYPE.SAVE_POINT:
			if not fromSave:
				if save.stage < stageNumber:
					save.stage = stageNumber
				PlayerService.save()


func _on_Dislodge_body_entered(body):
	if body is Player:
		hit()

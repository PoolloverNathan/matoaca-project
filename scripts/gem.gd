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

var COLORMAP = {
	TYPE.DECORATIVE: Color8(135, 242, 255),
	TYPE.SHIELD: Color8(255, 246, 9),
	TYPE.SAVE_POINT: Color8(0, 63, 173),
	TYPE.SUBLEVEL: Color8(255, 33, 33),
	TYPE.COLLECTIBLE: Color8(120, 220, 82),
	TYPE.BROWN: Color8(145, 70, 61),
	TYPE.BLACK: Color8(0, 0, 0),
	TYPE.TAN: Color8(229, 205, 196),
	TYPE.ORANGE: Color8(255, 129, 53),
	TYPE.PINK: Color8(255, 147, 196),
	TYPE.PURPLE: Color8(142, 46, 196)
}

export(TYPE) var type
## The name of the gem, used for tracking the gem's collection status.
export(NodePath) var target = null
## The stage number of the gem, if it is a save point.
export var stageNumber = 0
onready var target_node: Node2D = get_node(target) if target else null
export(NodePath) var spawn_at = null
onready var spawn_at_pos: Vector2 = get_node(spawn_at).global_position if spawn_at else Vector2(0, 0)
export(PackedScene) var level

func _ready():
	if Engine.editor_hint:
		return
	PlayerService.connect("save_loaded", self, "_save_loaded")
func _save_loaded(save):
	if save.get(name):
		sideEffect(true)
		$Gem.queue_free()
# func _save_loaded(save):

func get_color():
	return COLORMAP[type]

func hit():
	# if Engine.editor_hint:
	# 	return
	$Gem.mode = RigidBody2D.MODE_RIGID
	$Gem.apply_impulse(Vector2(0, 1), Vector2(30, -30))
	sideEffect(false)
func sideEffect(fromSave):
	var save = PlayerService.getSave()
	# if Engine.editor_hint:
	# 	return
	match type:
		TYPE.PURPLE:
			if target_node:
				target_node.queue_free()
				target_node = null
			continue
		TYPE.SUBLEVEL:
			if not fromSave:
				PlayerService.pushScene(level, true)
			continue
		TYPE.PINK:
			if not fromSave:
				PlayerService.pushScene(level, false)
			continue
		TYPE.COLLECTIBLE, TYPE.ORANGE, TYPE.PURPLE:
			if not fromSave: # don't waste time setting it
				save[name] = true
				PlayerService.worthSaving = true
			continue
		TYPE.ORANGE:
			PlayerService.popScene()
			continue
		_:
			if not fromSave and spawn_at_pos.length_squared() != 0:
				save.spawn_at = spawn_at_pos
				PlayerService.worthSaving = true
			if save.current_stage < stageNumber:
				save.current_stage = stageNumber
				PlayerService.worthSaving = true
			PlayerService.save()


func _on_Dislodge_body_entered(body):
	if body is Player:
		call_deferred("hit")
		$Dislodge.monitoring = false

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
	## A black gem that teleports the player.
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
export(NodePath) var disable_layer = null
export(NodePath) var enable_layer = null
## The stage number of the gem, if it is a save point.
export var stageNumber = 0
onready var disable_node: Node2D = get_node(disable_layer) if disable_layer else null
onready var enable_node: Node2D = get_node(enable_layer) if enable_layer else null
onready var enable_parent: Node2D = enable_node.get_parent() if enable_node else null
## Whether or not the gem respawns, if it is a black gem.
export var respawn = false
export(NodePath) var spawn_at = null
export(NodePath) var teleport_to = null
onready var spawn_at_pos: Vector2 = get_node(spawn_at).global_position if spawn_at else Vector2(0, 0)
onready var teleport_to_pos: Vector2 = get_node(teleport_to).global_position if teleport_to else global_position
export(PackedScene) var level
export(float) var launch_force = 30.0

func _get_configuration_warning():
	if launch_force < 0: return "launch_force must be >= 0"
	return ""

func _ready():
	if Engine.editor_hint:
		return
	PlayerService.connect("save_loaded", self, "_save_loaded")
	if enable_parent:
		enable_parent.remove_child(enable_node)
		
func _save_loaded(save, new):
	if not new and save.get(name):
		sideEffect(true)
		$Gem.queue_free()
		$Dislodge.queue_free()
# func _save_loaded(save):

func get_color():
	return COLORMAP[type]

func hit(direction: int):
	# if Engine.editor_hint:
	# 	return
	$Gem.mode = RigidBody2D.MODE_RIGID
	$Gem.apply_impulse(Vector2(0, 1), Vector2(launch_force, launch_force * direction))
	sideEffect(false)
func sideEffect(fromSave):
	var save = PlayerService.getSave()
	# if Engine.editor_hint:
	# 	return
	var wantToSave = false
	match type:
		_:
			if disable_node and disable_node.get_parent():
				save[name] = true
				disable_node.get_parent().remove_child(disable_node)
				PlayerService.worthSaving = true
			if enable_parent:
				save[name] = true
				enable_parent.add_child(enable_node)
				PlayerService.worthSaving = true
			continue
		TYPE.SUBLEVEL:
			if not fromSave:
				PlayerService.pushScene(level, true)
			continue
		TYPE.PINK:
			if not fromSave:
				PlayerService.pushScene(level, false)
			continue
		TYPE.BLACK:
			if not fromSave:
				var player = get_tree().get_nodes_in_group("player_unique").back() as Node2D
				BlackFade.fadeout()
				player.global_position = teleport_to_pos
				if respawn:
					var inst = load(filename).instance()
					get_parent().add_child_below_node(self, inst)
					call_deferred("queue_free")
				BlackFade.fadein()
		TYPE.COLLECTIBLE, TYPE.ORANGE, TYPE.DECORATIVE, TYPE.PURPLE:
			if not fromSave: # don't waste time setting it
				save[name] = true
				PlayerService.worthSaving = true
			continue
		TYPE.ORANGE:
			PlayerService.popScene()
			continue
		_:
			if wantToSave:
				PlayerService.save()


func _on_Dislodge_body_entered(body):
	if body is Player:
		call_deferred("hit", int(body.global_position.x > global_position.x) *2-1)
		$Dislodge.set_deferred("monitoring", false)

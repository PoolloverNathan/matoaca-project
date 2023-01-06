extends Node
var _savegame := Savegame.new()
export var savePrefix := "save_"
const green = ["gem_green_l1"]
const orange = []

func getOrangeGemCount():
	var total = 0
	var has = 0
	for key in orange:
		total += 1
		if _savegame.get(key):
			has += 1
	return [has, total]
func getGreenGemCount():
	var total = 0
	var has = 0
	for key in green:
		total += 1
		if _savegame.get(key):
			has += 1
	return [has, total]

func _ready():
	loadSave("save")

func getSave():
	return _savegame
func resetSave():
	_savegame = Savegame.new()
func save(name: String):
	var pscn := PackedScene.new()
	pscn.pack(_savegame)
	ResourceSaver.save("user://" + savePrefix + name + ".tscn", pscn)
func loadSave(name: String):
	if ResourceLoader.exists("user://" + savePrefix + name + ".tscn"):
		_savegame = load("user://" + savePrefix + name + ".tscn").get_instance()

class SceneEntry:
	var scene: PackedScene
	var user_can_pop = false
	func _init(_scene: PackedScene, _user_can_pop):
		scene = _scene
		user_can_pop = _user_can_pop
onready var scenes: Array = [SceneEntry.new(preload("res://levels/level1.tscn"), false)]
func pushScene(scene: PackedScene, user_can_pop = false):
	scenes.push_back(SceneEntry.new(scene, user_can_pop))
	get_tree().change_scene_to(scene)
func popScene():
	scenes.pop_back()
	get_tree().change_scene_to(scenes.back().scene)

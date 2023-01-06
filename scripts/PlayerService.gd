extends Node
var _savegame := Savegame.new()
export var savePrefix := "save_"

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

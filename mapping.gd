tool extends EditorScript

func _run():
	var file = File.new()
	file.open("res://mapping.json", File.WRITE)
	file.store_string("""{
		
	}""")
	file.close()

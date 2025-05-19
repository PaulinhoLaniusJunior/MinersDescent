extends Node

var file_path = "user://saveData.save"

var save_data = {
	"health":200,
	"money":0
}

func save_game():
	
	var file_save = FileAccess.open(file_path, FileAccess.WRITE)
	file_save.store_var(save_data)
	file_save.close()
	
func load_game():
	
	if FileAccess.file_exists(file_path):
		var fileLoad = FileAccess.open(file_path, FileAccess.READ)
		save_data = fileLoad.get_var()
		return save_data
	else:
		print("File Not Found")
		return save_data

func save_all_parameters(data:Dictionary):
	
	save_data = data
	save_game()

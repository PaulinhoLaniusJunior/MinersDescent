extends Control


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/lobby.tscn")


func _on_controls_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()

extends Control

func _ready():
	$miner.play("miner")
	$slime.play("idle")
	
func _on_start_game_pressed() -> void:
	await get_tree().create_timer(0.8).timeout
	
	get_tree().change_scene_to_file("res://scenes/worlds/lobby.tscn")

func _on_exit_game_pressed() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

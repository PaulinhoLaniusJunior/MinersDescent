extends CharacterBody2D

# --- Referências de Nós ---
@onready var sound_player: AudioStreamPlayer2D = $BlacksmithSoundPlayer

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$ShopScene/CanvasLayer.visible = false
	$CanvasLayer.visible = false
	if is_instance_valid(sound_player):
		sound_player.play()
	else:
		printerr("FERREIRO: Nó AudioStreamPlayer2D 'BlacksmithSoundPlayer' não encontrado.")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$CanvasLayer.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
		$ShopScene/CanvasLayer.visible = false
		$CanvasLayer.visible = false

func _on_button_pressed() -> void:
	$ShopScene/CanvasLayer.visible = true
	$CanvasLayer.visible = false

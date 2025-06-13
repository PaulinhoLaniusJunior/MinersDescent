extends StaticBody2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$CanvasLayer.visible = false
	$Area2D/SHOPMENU/menu.visible = false
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$CanvasLayer.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	$Area2D/SHOPMENU/menu.visible = false
	$CanvasLayer.visible = false


func _on_button_pressed() -> void:
	$Area2D/SHOPMENU/menu.visible = true
	$CanvasLayer.visible = false

extends StaticBody2D

var player = null
var priceKey1 = 5000
var priceKey2 = 20000
var priceKey3 = 100000

var comprandochave = 0

func _physics_process(delta):
	if self.visible == true:
		pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body

func buy():
	if comprandochave == 1:
			player.money -= priceKey1
			player.key1 = true
	if comprandochave == 2:
			player.money -= priceKey2
			player.key2 = true
	if comprandochave == 3:
			player.money -= priceKey3
			player.key3 = true


func _on_buy_key_1_pressed() -> void:
	print("botao apertado")
	comprandochave = 1
	if player.money >= priceKey1:
		if player.key1 == false:
			buy()


func _on_buy_key_2_pressed() -> void:
	print("botao 2 apertado")
	comprandochave = 2
	if player.money >= priceKey2:
		if player.key2 == false:
			buy()


func _on_buy_key_3_pressed() -> void:
	print("botao 3 apertado")
	comprandochave = 3
	if player.money >= priceKey3:
		if player.key3 == false:
			buy()

extends StaticBody2D

@onready var shop_menu_node: CanvasLayer = $menu

# Informações centralizadas sobre cada chave
var keys_info = {
	"key1": {
		"name": "Chave da Caverna Escura",
		"price": 5000,
		"global_flag_name": "key1",
		"button_node": null,
		"price_label_node": null
	},
	"key2": {
		"name": "Chave do Pântano",
		"price": 20000,
		"global_flag_name": "key2",
		"button_node": null,
		"price_label_node": null
	},
	"key3": {
		"name": "Chave do Castelo",
		"price": 100000,
		"global_flag_name": "key3",
		"button_node": null,
		"price_label_node": null
	},
	"key4": {
		"name": "Chave do Vulcão",
		"price": 200000,
		"global_flag_name": "key4",
		"button_node": null,
		"price_label_node": null
	}
}

# Botões 
@onready var buy_key_1_button: Button = $menu/Panel/buyKey1
@onready var buy_key_2_button: Button = $menu/Panel/buyKey2
@onready var buy_key_3_button: Button = $menu/Panel/buyKey3
@onready var buy_key_4_button: Button = $menu/Panel/buyKey4
@onready var exit_button: Button = $menu/ExitButton

@onready var price_label_key1: Label = $menu/Panel/buyKey1/price1
@onready var price_label_key2: Label = $menu/Panel/buyKey2/price2
@onready var price_label_key3: Label = $menu/Panel/buyKey3/price3
@onready var price_label_key4: Label = $menu/Panel/buyKey4/price4

@onready var purchase_sound_player: AudioStreamPlayer = $PurchaseSoundPlayer

func _ready() -> void:
	shop_menu_node.visible = false

	# Atribuições
	keys_info["key1"]["button_node"] = buy_key_1_button
	keys_info["key2"]["button_node"] = buy_key_2_button
	keys_info["key3"]["button_node"] = buy_key_3_button
	keys_info["key4"]["button_node"] = buy_key_4_button

	keys_info["key1"]["price_label_node"] = price_label_key1
	keys_info["key2"]["price_label_node"] = price_label_key2
	keys_info["key3"]["price_label_node"] = price_label_key3
	keys_info["key4"]["price_label_node"] = price_label_key4
	
	# Conexões de sinais
	if buy_key_1_button:
		buy_key_1_button.pressed.connect(_on_buy_key_pressed.bind("key1"))
	if buy_key_2_button:
		buy_key_2_button.pressed.connect(_on_buy_key_pressed.bind("key2"))
	if buy_key_3_button:
		buy_key_3_button.pressed.connect(_on_buy_key_pressed.bind("key3"))
	if buy_key_4_button:
		buy_key_4_button.pressed.connect(_on_buy_key_pressed.bind("key4"))
	if exit_button:
		exit_button.pressed.connect(_on_exit_button_pressed)
		
	update_shop_ui()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if shop_menu_node:
			shop_menu_node.visible = true
			update_shop_ui()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		if shop_menu_node:
			shop_menu_node.visible = false


func _on_buy_key_pressed(key_id: String) -> void:
	if not keys_info.has(key_id):
		printerr("Tentativa de comprar chave desconhecida: ", key_id)
		return

	var key_data = keys_info[key_id]
	var player_has_key = global.get(key_data["global_flag_name"])

	if player_has_key:
		print("Jogador já possui a ", key_data.get("name", key_id))
		return

	if global.get_currency() >= key_data["price"]:
		if is_instance_valid(purchase_sound_player):
			purchase_sound_player.play()
			
		global.spend_currency(key_data["price"])
		global.set(key_data["global_flag_name"], true) 
		print("Comprou a ", key_data.get("name", key_id), "!")

	update_shop_ui()


func update_shop_ui() -> void:
	var current_money = global.get_currency()

	for key_id in keys_info:
		var key_data = keys_info[key_id]
		var button = key_data["button_node"]
		var price_label = key_data["price_label_node"]
		
		if not is_instance_valid(button):
			continue

		var player_has_key = global.get(key_data["global_flag_name"])

		if is_instance_valid(price_label):
			price_label.text = str(key_data["price"])

		if player_has_key:
			button.disabled = true
			button.text = "Comprado"
			if is_instance_valid(price_label):
				price_label.text = "-"
		else:
			button.disabled = false
			button.text = "Comprar " + key_data.get("name", key_id).split(" ")[0]
			if current_money < key_data["price"]:
				button.modulate = Color(0.7, 0.7, 0.7)
			else:
				button.modulate = Color(1, 1, 1)
				

func _on_exit_button_pressed() -> void:
	if shop_menu_node:
		shop_menu_node.visible = false

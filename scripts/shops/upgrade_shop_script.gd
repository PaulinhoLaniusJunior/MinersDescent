extends Control

# --- Sinais ---
signal shop_closed

# --- Referências de Nós ---
@onready var mining_damage_button: Button = $CanvasLayer/UpgradesContainer/Mining/MiningDamageUpgradeButton
@onready var mining_damage_name_label: Label = $CanvasLayer/UpgradesContainer/Mining/MiningDamageUpgradeButton/UpgradeNameLabel
@onready var mining_damage_cost_label: Label = $CanvasLayer/UpgradesContainer/Mining/MiningDamageUpgradeButton/UpgradeCostLabel
@onready var mining_damage_level_label: Label = $CanvasLayer/UpgradesContainer/Mining/MiningDamageUpgradeButton/UpgradeLevelLabel

@onready var attack_damage_button: Button = $CanvasLayer/UpgradesContainer/attack/AttackDamageUpgradeButton
@onready var attack_damage_name_label: Label = $CanvasLayer/UpgradesContainer/attack/AttackDamageUpgradeButton/UpgradeNameLabel
@onready var attack_damage_cost_label: Label = $CanvasLayer/UpgradesContainer/attack/AttackDamageUpgradeButton/UpgradeCostLabel
@onready var attack_damage_level_label: Label = $CanvasLayer/UpgradesContainer/attack/AttackDamageUpgradeButton/UpgradeLevelLabel

@onready var health_upgrade_button: Button = $CanvasLayer/UpgradesContainer/Health/HealthUpgradeButton
@onready var health_upgrade_name_label: Label = $CanvasLayer/UpgradesContainer/Health/HealthUpgradeButton/UpgradeNameLabel
@onready var health_upgrade_cost_label: Label = $CanvasLayer/UpgradesContainer/Health/HealthUpgradeButton/UpgradeCostLabel
@onready var health_upgrade_level_label: Label = $CanvasLayer/UpgradesContainer/Health/HealthUpgradeButton/UpgradeLevelLabel

@onready var exit_button: Button = $CanvasLayer/UpgradesContainer/ExitButton

@onready var purchase_sound_player: AudioStreamPlayer = $PurchaseSoundPlayer


# --- IDs dos Upgrades ---
const MINING_UPGRADE_ID = "mining_damage"
const ATTACK_UPGRADE_ID = "attack_damage"
const HEALTH_UPGRADE_ID = "health_upgrade"

var mining_upgrade_data: Dictionary
var attack_upgrade_data: Dictionary
var health_upgrade_data: Dictionary

func _ready():
	if not global.get("UPGRADE_DEFINITIONS"):
		printerr("ERRO CRÍTICO: Autoload 'global' encontrado, mas 'UPGRADE_DEFINITIONS' não está definido dentro dele ou é nulo.")
		get_tree().quit()
		return

	# Obter dados de upgrade do global
	mining_upgrade_data = global.UPGRADE_DEFINITIONS[MINING_UPGRADE_ID]
	attack_upgrade_data = global.UPGRADE_DEFINITIONS[ATTACK_UPGRADE_ID]
	health_upgrade_data = global.UPGRADE_DEFINITIONS[HEALTH_UPGRADE_ID]
	
	# Conectar sinais dos botões
	if mining_damage_button:
		mining_damage_button.pressed.connect(_on_upgrade_button_pressed.bind(MINING_UPGRADE_ID))
	else:
		printerr("ERRO: Nó 'MiningDamageUpgradeButton' não encontrado.")

	if attack_damage_button:
		attack_damage_button.pressed.connect(_on_upgrade_button_pressed.bind(ATTACK_UPGRADE_ID))
	else:
		printerr("ERRO: Nó 'AttackDamageUpgradeButton' não encontrado.")
		
	if health_upgrade_button:
		health_upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(HEALTH_UPGRADE_ID))
	else:
		printerr("ERRO: Nó 'HealthUpgradeButton' não encontrado.")
		
	if exit_button:
		exit_button.pressed.connect(_on_exit_button_pressed)
	else:
		printerr("ERRO: Nó 'ExitButton' não encontrado.")
	
	update_shop_ui()


func update_shop_ui():
	# --- Atualizar Botão de Upgrade de Mineração ---
	if mining_damage_name_label and mining_damage_level_label and mining_damage_cost_label and mining_damage_button:
		var current_mining_level = global.get_upgrade_level(MINING_UPGRADE_ID)
		mining_damage_name_label.text = mining_upgrade_data.get("name", "N/A")
		mining_damage_level_label.text = "Nível: %d/%d" % [current_mining_level, mining_upgrade_data.get("max_level", 0)]

		if current_mining_level >= mining_upgrade_data.get("max_level", 0):
			mining_damage_cost_label.text = "MAX"
			mining_damage_button.disabled = true
		else:
			var mining_cost = calculate_upgrade_cost(MINING_UPGRADE_ID, current_mining_level)
			mining_damage_cost_label.text = "Custo: " + str(mining_cost)
			mining_damage_button.disabled = global.get_currency() < mining_cost
	
	# --- Atualizar Botão de Upgrade de Ataque ---
	if attack_damage_name_label and attack_damage_level_label and attack_damage_cost_label and attack_damage_button:
		var current_attack_level = global.get_upgrade_level(ATTACK_UPGRADE_ID)
		attack_damage_name_label.text = attack_upgrade_data.get("name", "N/A")
		attack_damage_level_label.text = "Nível: %d/%d" % [current_attack_level, attack_upgrade_data.get("max_level", 0)]

		if current_attack_level >= attack_upgrade_data.get("max_level", 0):
			attack_damage_cost_label.text = "MAX"
			attack_damage_button.disabled = true
		else:
			var attack_cost = calculate_upgrade_cost(ATTACK_UPGRADE_ID, current_attack_level)
			attack_damage_cost_label.text = "Custo: " + str(attack_cost)
			attack_damage_button.disabled = global.get_currency() < attack_cost

	# --- Atualizar Botão de Upgrade de Vida ---
	if health_upgrade_name_label and health_upgrade_level_label and health_upgrade_cost_label and health_upgrade_button:
		var current_health_level = global.get_upgrade_level(HEALTH_UPGRADE_ID)
		health_upgrade_name_label.text = health_upgrade_data.get("name", "N/A")
		health_upgrade_level_label.text = "Nível: %d/%d" % [current_health_level, health_upgrade_data.get("max_level", 0)]

		if current_health_level >= health_upgrade_data.get("max_level", 0):
			health_upgrade_cost_label.text = "MAX"
			health_upgrade_button.disabled = true
		else:
			var health_cost = calculate_upgrade_cost(HEALTH_UPGRADE_ID, current_health_level)
			health_upgrade_cost_label.text = "Custo: " + str(health_cost)
			health_upgrade_button.disabled = global.get_currency() < health_cost


func calculate_upgrade_cost(upgrade_id: String, current_level: int) -> int:
	if not global.UPGRADE_DEFINITIONS.has(upgrade_id):
		printerr("ID de upgrade desconhecido ('%s') para cálculo de custo em global.UPGRADE_DEFINITIONS." % upgrade_id)
		return 999999
		
	var upgrade_def = global.UPGRADE_DEFINITIONS[upgrade_id]
	var cost = upgrade_def["base_cost"] * pow(upgrade_def["cost_increase_factor"], current_level)
	return int(round(cost))

func _on_upgrade_button_pressed(upgrade_id: String):
	var current_level = global.get_upgrade_level(upgrade_id)
	if not global.UPGRADE_DEFINITIONS.has(upgrade_id):
		printerr("Tentativa de comprar upgrade desconhecido: ", upgrade_id)
		return
		
	var upgrade_def = global.UPGRADE_DEFINITIONS[upgrade_id]
	
	if current_level < upgrade_def["max_level"]:
		var cost = calculate_upgrade_cost(upgrade_id, current_level)
		if global.get_currency() >= cost:
			if is_instance_valid(purchase_sound_player):
				purchase_sound_player.play()
			
			global.spend_currency(cost)
			global.apply_and_save_upgrade(upgrade_id)
			update_shop_ui()
			
			print("Shop: Dinheiro insuficiente para comprar " + upgrade_def.get("name", "Upgrade Desconhecido"))
	else:
		print("Shop: " + upgrade_def.get("name", "Upgrade Desconhecido") + " já está no nível máximo.")

func _on_exit_button_pressed():
	$CanvasLayer.visible = false
	close_shop()

func open_shop():
	update_shop_ui()
	show()

func close_shop():
	hide()
	emit_signal("shop_closed")

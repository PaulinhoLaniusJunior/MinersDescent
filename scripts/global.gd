extends Node

# Status
@export var money = 0
var health = 200
const speed = 70
var player_alive = true

# Keys
var key1 = false
var key2 = false
var key3 = false

# Estados do Jogador
var player_current_attack = false
var player_current_mining = false
var destination_level : String = ""
var transition_scene = false

# Danos Atuais
var MinerDamage = 2
var AtackDamage = 20

# Níveis dos Upgrades
var upgrade_levels = {
	"mining_damage": 0,
	"attack_damage": 0
}

# --- DADOS DOS UPGRADES (Centralizado para consistência) ---
const UPGRADE_DEFINITIONS = {
	"mining_damage": {
		"name": "Dano de Mineração +",
		"base_cost": 50,
		"cost_increase_factor": 1.5,
		"damage_increase_per_level": 5,
		"max_level": 10
	},
	"attack_damage": {
		"name": "Dano de Ataque +",
		"base_cost": 70,
		"cost_increase_factor": 1.6,
		"damage_increase_per_level": 3,
		"max_level": 8
	}
}

const SAVE_FILE_PATH = "user://game_save.dat"

func _ready():
	print("Caminho user:// do projeto: ", OS.get_user_data_dir())
	load_game()

func finish_changescenes():
	pass

# --- Funções de Moeda e Upgrade ---
func get_currency() -> int:
	return money

func spend_currency(amount: int):
	money -= amount
	if money < 0:
		money = 0
	save_game()

func add_currency(amount: int):
	money += amount
	save_game()

func get_upgrade_level(upgrade_id: String) -> int:
	if upgrade_levels.has(upgrade_id):
		return upgrade_levels[upgrade_id]
	printerr("Tentativa de obter nível para upgrade desconhecido: ", upgrade_id)
	return 0

func apply_and_save_upgrade(upgrade_id: String):
	if not UPGRADE_DEFINITIONS.has(upgrade_id):
		printerr("Tentativa de aplicar upgrade desconhecido: ", upgrade_id)
		return

	var upgrade_info = UPGRADE_DEFINITIONS[upgrade_id]
	var current_level = get_upgrade_level(upgrade_id)

	if current_level < upgrade_info["max_level"]:
		upgrade_levels[upgrade_id] += 1
		
		if upgrade_id == "mining_damage":
			MinerDamage += upgrade_info["damage_increase_per_level"]
			print("Global: Dano de Mineração aumentado para ", MinerDamage, " Nível: ", upgrade_levels[upgrade_id])
		elif upgrade_id == "attack_damage":
			AtackDamage += upgrade_info["damage_increase_per_level"]
			print("Global: Dano de Ataque aumentado para ", AtackDamage, " Nível: ", upgrade_levels[upgrade_id])
		
		save_game()
	else:
		print("Global: Tentativa de upar ", upgrade_id, " além do nível máximo.")


func get_current_mining_damage() -> int:
	return MinerDamage

func get_current_attack_damage() -> int:
	return AtackDamage

# --- Sistema de Salvar/Carregar ---
func save_game():
	var save_data = {
		"money": money,
		"health": health,
		"key1": key1,
		"miner_damage_current": MinerDamage,
		"attack_damage_current": AtackDamage,
		"upgrade_levels": upgrade_levels,
	}
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		print("Global: Jogo salvo!")
	else:
		printerr("Global: Erro ao salvar o jogo.")

func load_game():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Global: Arquivo de save não encontrado. Usando valores padrão.")
		return

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var parse_result = JSON.parse_string(json_string)
		
		if parse_result:
			money = parse_result.get("money", 0)
			health = parse_result.get("health", 200)
			key1 = parse_result.get("key1", false)
			
			MinerDamage = parse_result.get("miner_damage_current", 2)
			AtackDamage = parse_result.get("attack_damage_current", 20)
			
			var loaded_levels = parse_result.get("upgrade_levels", {})
			for key in loaded_levels:
				if upgrade_levels.has(key):
					upgrade_levels[key] = loaded_levels[key]
			
			print("Global: Jogo carregado!")
			print("Global: Dinheiro: %d, Dano Min: %d, Dano Atk: %d" % [money, MinerDamage, AtackDamage])
			print("Global: Níveis de Upgrade: ", upgrade_levels)
		else:
			printerr("Global: Erro ao carregar o jogo (parse JSON). Usando valores padrão.")
	else:
		printerr("Global: Erro ao carregar o jogo (abrir arquivo). Usando valores padrão.")

# Chamado para resetar o progresso para um novo jogo, por exemplo.
func reset_to_default_values():
	money = 0
	health = 200
	key1 = false
	key2 = false
	key3 = false
	MinerDamage = UPGRADE_DEFINITIONS["mining_damage"].get("base_value_if_any", 2)
	AtackDamage = UPGRADE_DEFINITIONS["attack_damage"].get("base_value_if_any", 20)
	
	upgrade_levels = {
		"mining_damage": 0,
		"attack_damage": 0
	}
	print("Global: Valores resetados para o padrão.")
	save_game()

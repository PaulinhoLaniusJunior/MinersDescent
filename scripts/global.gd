extends Node

#status
@export var money = 5000
var health = 200
const speed = 70
var player_alive = true

#keys
var key1 = false
var key2 = false
var key3 = false

var player_current_attack = false
var player_current_mining = false
var destination_level : String = ""
var transition_scene = false

var MinerDamage = 2

func finish_changescenes():
	pass

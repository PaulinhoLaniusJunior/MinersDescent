extends CharacterBody2D

var speed = 55
var player_chase = false
var player: Player = null

var health = 200
var player_in_attack_zone = false
var can_take_damage = true

# --- Variáveis de estado de ataque ---
var is_attacking = false
var attack_cooldown = true
@export var damage_amount: int = 15 
@export var effective_attack_range: float = 40.0 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $healthbar
@onready var take_damage_cooldown: Timer = $take_damage_cooldown
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)

func _physics_process(delta):
	update_health()
	if is_attacking or health <= 0:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	# Lógica de Perseguição
	if player_chase and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		animated_sprite.play("walk")
		animated_sprite.flip_h = (velocity.x < 0)
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")

	move_and_slide()
	
	# --- Trigger de Ataque por Colisão Física ---
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision and collision.get_collider() is Player:
			attack()
			break

	deal_with_damage()


# --- Funções de Detecção ---
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_attack_zone = false

# --- Funções de Combate ---
func deal_with_damage():
	if player_in_attack_zone and global.player_current_attack and can_take_damage:
		health -= global.AtackDamage
		can_take_damage = false
		take_damage_cooldown.start()
		print("INIMIGO: Vida restante = ", health)
		
		if health <= 0:
			die()

func die():
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	queue_free()

# Função para o esqueleto ATACAR
func attack():
	if attack_cooldown and not is_attacking:
		is_attacking = true
		attack_cooldown = false
		animated_sprite.play("attack")
		
		if is_instance_valid(player) and global_position.distance_to(player.global_position) <= effective_attack_range:
			print("Esqueleto atacou e causou %d de dano!" % damage_amount)
			global.health -= damage_amount 
		attack_cooldown_timer.start()

func _on_attack_cooldown_timer_timeout():
	attack_cooldown = true

func _on_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
		animated_sprite.play("idle")


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	healthbar.value = health
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true

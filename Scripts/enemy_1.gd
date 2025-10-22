extends CharacterBody2D
class_name Enemy

@onready var animplayer: AnimationPlayer = $AnimationPlayer
@export var speed: int = 150
@export var player: Player
@export var ENEMYBULLET: PackedScene

var player_chase: bool = false
var enemyhealth: int = 3
var shoot_cooldown: float = 0.7 
var shoot_timer: float = 0.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up") or \
	   Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") or \
	   Input.is_action_just_pressed("shoot"):
		player_chase = true
	
	if player_chase and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		look_at(player.position)
		move_and_slide()
		
		shoot_timer -= delta
		if shoot_timer <= 0.0:
			shoot_bullet()
			shoot_timer = shoot_cooldown

func _takeDamage(amount: int) -> void:
	if amount > 0:
		enemyhealth -= amount
		animplayer.play("death")
		
		if enemyhealth <= 0:
			queue_free()
			print("Enemy destroyed")

func shoot_bullet() -> void:
	if ENEMYBULLET:
		var bullet = ENEMYBULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = rotation

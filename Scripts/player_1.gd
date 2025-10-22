extends CharacterBody2D
class_name Player

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var health: CanvasLayer = $Health
@export var BULLET: PackedScene

var direction: int = 0
var heartslist: Array = []
var playerhealth: int = 5

signal player_death()

func _ready() -> void:
	playerhealth = GlobalManager.player_health
	GlobalManager.player_dead = false
	
	if GlobalManager.player_health <= 0:
		GlobalManager.player_dead = true
		emit_signal("player_death")
	
	var hearts_parent = $Health/Lives/Panel/HBoxContainer
	heartslist.clear()
	for child in hearts_parent.get_children():
		if child.has_node("Sprite2D"):
			heartslist.append(child.get_node("Sprite2D"))
		elif child is Sprite2D:
			heartslist.append(child)
	
	print("Collected hearts:", heartslist.size())
	update_hearts_display()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and BULLET:
		$Shoot.play()
		var bullet = BULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = rotation
	
	if GlobalManager.player_dead:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * GlobalManager.player_speed
	
	if Input.is_action_pressed("left"):
		direction = -1
	elif Input.is_action_pressed("right"):
		direction = 1

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	get_input()
	move_and_slide()

func _takeDamage(amount: int) -> void:
	if amount > 0:
		playerhealth -= amount
		GlobalManager.player_health = playerhealth 
		anim_player.play("death")
		update_hearts_display()
		
		if playerhealth <= 0:
			GlobalManager.player_dead = true

func update_hearts_display() -> void:
	for i in range(heartslist.size()):
		heartslist[i].visible = i < playerhealth

func _on_level_player_won() -> void:
	set_process(false)
	set_physics_process(false)

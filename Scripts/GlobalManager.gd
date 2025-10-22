extends Node2D

@export var level_number: int = 1
@export var leveltochange: PackedScene

var level_cleared := false
var current_lev: int = 1
var change_level: bool = false
var player_health: int = 5
var player_speed: int = 400
var player_dead: bool = false
var bullet_player_speed: int = 500

signal player_won()

func _ready() -> void:
	current_lev = level_number
	change_level = false

func reset_game() -> void:
	player_health = 5
	player_speed = 400
	player_dead = false
	bullet_player_speed = 500

func _process(_delta: float) -> void:
	if not level_cleared:
		var enemies = get_tree().get_nodes_in_group("Enemy")
		
		if enemies.is_empty() and not change_level:
			print("All enemies defeated! Changing level...")
			level_cleared = true 
			change_level_after_delay()

func change_level_after_delay() -> void:
	change_level = true
	print("Waiting 1 second before level change...")
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	current_lev += 1
	
	emit_signal("player_won")
	
	if leveltochange:
		print("Changing to next level scene...")
		get_tree().change_scene_to_packed(leveltochange)
	else:
		print("ERROR: No level scene assigned to leveltochange!")

func _finished() -> void:
	get_tree().change_scene_to_packed(leveltochange)

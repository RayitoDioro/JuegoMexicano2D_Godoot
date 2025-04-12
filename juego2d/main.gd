extends Node

@export var mob_scene: PackedScene
var time = 0
var points = 0
var bottom_margin := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	$Collectible.hide()

func new_game():
	time = 0
	points = 0
	$HUD.update_points(points)
	$HUD.update_score(time)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$Collectible.appear_randomly()
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	#mob.position = mob_spawn_location.position
	
	var screen_size = $Player.get_viewport_rect().size
	var position = mob_spawn_location.position
	position.y = clamp(position.y, 0, screen_size.y - bottom_margin)
	mob.position = position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	time += 1
	$HUD.update_score(time)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_collectible_collected() -> void:
	points += 1
	$HUD.update_points(points)

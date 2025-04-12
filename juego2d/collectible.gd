extends Area2D

signal collected

var bottom_margin := 100

func appear_randomly():
	var screen_size = get_viewport_rect().size
	position = Vector2(
		randi() % int(screen_size.x),
		randi() % int(screen_size.y - bottom_margin)
	)
	show()

func _ready():
	randomize()
	hide()  # Ocultar al inicio

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "Player":
		emit_signal("collected")
		appear_randomly()

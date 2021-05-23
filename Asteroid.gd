extends Area2D

var explosion_scene = preload("res://Explosion.tscn")

var move_speed = 100.0
var score_emitted = false

signal score

func _process(delta):
	position -= Vector2(move_speed *delta, 0.0)
	if position.x <= -100:
		queue_free()

func _on_Asteroid_area_entered(area):
	if area.is_in_group("shot") or area.is_in_group("players"):
		if not score_emitted:
			score_emitted = true
			emit_signal("score")
			queue_free()
			
			var stage_node = get_parent()
			var explosion_instance = explosion_scene.instance()
			explosion_instance.position = position
			stage_node.add_child(explosion_instance)

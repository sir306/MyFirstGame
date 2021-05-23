extends Area2D
const MOVE_SPEED = 150.0
const SCREEN_HEIGHT = 180
const SCREEN_WIDTH = 320
var shot_scene = preload("res://Shot.tscn")
var explosion_scene = preload("res://Explosion.tscn")
var can_shoot = true

signal destroyed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Vector2()
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	
	position += (delta * MOVE_SPEED) * input_dir
	
	if position.x < 0.0:
		position.x = 0.0
	elif position.x > SCREEN_WIDTH:
		position.x = SCREEN_WIDTH
	elif position.y < 0.0:
		position.y = 0.0
	elif position.y > SCREEN_HEIGHT:
		position.y = SCREEN_HEIGHT
	
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		var stage_node = get_parent()
		
		var shot_instance = shot_scene.instance()
		shot_instance.position = position
		shot_instance.position.y += 5
		stage_node.add_child(shot_instance)
		
		var shot_instance2 = shot_scene.instance()
		shot_instance2.position = position
		shot_instance2.position.y -= 5
		stage_node.add_child(shot_instance2)
		
		can_shoot = false
		get_node("Ship/Reload_Timer").start()


func _on_Reload_Timer_timeout():
	can_shoot = true


func _on_Player_area_entered(area):
	if area.is_in_group("asteroid"):
		queue_free()
		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()
		explosion_instance.position = position
		stage_node.add_child(explosion_instance)
		emit_signal("destroyed")
		

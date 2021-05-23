extends Node2D
var is_game_over = false
var asteroid = preload("res://Asteroid.tscn")
const WIDTH = 320
const HEIGHT = 180
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Player").connect("destroyed", self, "on_player_destroyed")
	get_node("spawn_timer").connect("timeout", self, "_on_spawn_timer_timeout")
	get_node("Asteroid").connect("score", self, "_on_player_score")

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if is_game_over and Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://Stage.tscn")

func on_player_destroyed():
	get_node("ui/retry").show()
	is_game_over = true

func _on_spawn_timer_timeout():
	var asteroid_instance = asteroid.instance()
	asteroid_instance.position = Vector2(WIDTH + 8, rand_range(0, HEIGHT))
	asteroid_instance.connect("score", self, "_on_player_score")
	asteroid_instance.move_speed += score
	get_node("spawn_timer").wait_time *= 0.99
	add_child(asteroid_instance)
	
func _on_player_score():
	score += 1
	get_node("ui/score").text = "Score: " + str(score)

extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var todos_suelos
var s_invisible
var jugadores = 1
var puntaje_j1 = 0
var puntaje_j2 = 0
var highscore = 500
var gano = false
	
func iniciar():
	todos_suelos = get_tree().get_nodes_in_group("suelo")
	s_invisible = get_tree().get_nodes_in_group("sinvisible")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

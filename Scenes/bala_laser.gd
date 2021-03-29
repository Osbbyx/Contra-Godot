extends KinematicBody2D

var Velocidad = Vector2()
export var potencia = 0
var id = 1

func _ready():
	Velocidad.x = 0
	Velocidad.y = 0
	for suelo in game_handler.todos_suelos:
		add_collision_exception_with(suelo)
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		add_collision_exception_with(player)
	for suelo in game_handler.s_invisible:
		add_collision_exception_with(suelo)
	var powerupabiertos = get_tree().get_nodes_in_group("powerupabierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
	for i in 3:
		get_node("1").add_collision_exception_with(get_node(String(i+1)))
		get_node("2").add_collision_exception_with(get_node(String(i+1)))
		get_node("3").add_collision_exception_with(get_node(String(i+1)))
		var jugadores = get_tree().get_nodes_in_group("player")
		for player in jugadores:
			get_node(String(i+1)).add_collision_exception_with(player)

		
		
func _physics_process(delta):
	rotation = Velocidad.angle()	
	var movimiento = Velocidad * delta
	var obj_colisionado = []
	move_and_collide(movimiento)
	
	for i in 3:
		if(get_node(String(i+1)) != null):
			obj_colisionado.append(get_node(String(i+1)).move_and_collide(movimiento))
			if(obj_colisionado[i] != null):
				obj_colisionado[i] = obj_colisionado[i].collider
				if(obj_colisionado[i].is_in_group("enemigo")):
					if(obj_colisionado[i].is_in_group("boss")):
						obj_colisionado[i] = obj_colisionado[i].get_parent()
					obj_colisionado[i].recibir_golpe(id)
					queue_free()
				elif(obj_colisionado[i].is_in_group("powerup")):
					obj_colisionado[i].explotar()
					queue_free()



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

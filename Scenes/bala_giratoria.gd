extends KinematicBody2D

var Velocidad = Vector2()
export var potencia = 0
export var vel_rotacion = 1
var id = 1

func _ready():
	Velocidad.x = 0
	Velocidad.y = 0
	for suelo in game_handler.todos_suelos:
		add_collision_exception_with(suelo)
	var players = get_node("1").get_tree().get_nodes_in_group("player")
	for player in players:
		get_node("1").add_collision_exception_with(player)
	for suelo in game_handler.s_invisible:
		get_node("1").add_collision_exception_with(suelo)
	var powerupabiertos = get_tree().get_nodes_in_group("powerupabierto")
	for powerupabierto in powerupabiertos:
		get_node("1").add_collision_exception_with(powerupabierto)
		
		
func _physics_process(delta):
	rotate(vel_rotacion / delta)
	var movimiento = Velocidad  * delta
	move_and_collide(movimiento)
	var obj_colisionado
	
	if(get_node("1") != null):
		obj_colisionado = get_node("1").move_and_collide(movimiento)
	
	if(get_node("1") != null):
		if(obj_colisionado != null):
			obj_colisionado = obj_colisionado.collider
			if(obj_colisionado.is_in_group("enemigo")):
				if(obj_colisionado.is_in_group("boss")):
					obj_colisionado = obj_colisionado.get_parent()
				obj_colisionado.recibir_golpe(id)
				queue_free()
			elif(obj_colisionado.is_in_group("powerup")):
				obj_colisionado.explotar()
			queue_free()



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

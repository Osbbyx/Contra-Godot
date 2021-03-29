extends KinematicBody2D

var Velocidad = Vector2()
var Velocidad_minibalas = Vector2()
var id = 1
export var potencia = 0

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
	get_node("2").rotation_degrees = 22
	get_node("3").rotation_degrees = 44
	get_node("4").rotation_degrees = -22
	get_node("5").rotation_degrees = -44
	for i in 5:
		get_node("1").add_collision_exception_with(get_node(String(i+1)))
		get_node("2").add_collision_exception_with(get_node(String(i+1)))
		get_node("3").add_collision_exception_with(get_node(String(i+1)))
		get_node("4").add_collision_exception_with(get_node(String(i+1)))
		get_node("5").add_collision_exception_with(get_node(String(i+1)))
		for suelo in game_handler.todos_suelos:
			get_node(String(i+1)).add_collision_exception_with(suelo)
		for suelo in game_handler.s_invisible:
			get_node(String(i+1)).add_collision_exception_with(suelo)
		for player in players:
			get_node(String(i+1)).add_collision_exception_with(player)
	
		
		
func _physics_process(delta):
	var angulo = Velocidad.angle()
	var movimiento = Velocidad * delta
	move_and_collide(movimiento)
	var obj_colisionado = []
	for i in 5:
		if(get_node(String(i+1)) != null):
			Velocidad_minibalas.x = potencia * cos(get_node(String(i+1)).rotation + angulo)
			Velocidad_minibalas.y = potencia * sin(get_node(String(i+1)).rotation + angulo)
			movimiento = Velocidad_minibalas * delta
			obj_colisionado.append(get_node(String(i+1)).move_and_collide(movimiento))
	
	
	for i in 5:
		if(get_node(String(i+1)) != null):
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

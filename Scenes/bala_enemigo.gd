extends KinematicBody2D

var Velocidad = Vector2()
export var potencia = 0

func _ready():
	Velocidad.x = 0
	Velocidad.y = 0
	for suelo in game_handler.todos_suelos:
		add_collision_exception_with(suelo)
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	for enemigo in enemigos:
		add_collision_exception_with(enemigo)
	for suelo in game_handler.s_invisible:
		add_collision_exception_with(suelo)
	var powerups = get_tree().get_nodes_in_group("powerup")
	for powerup in powerups:
		add_collision_exception_with(powerup)
	var powerupabiertos = get_tree().get_nodes_in_group("powerupabierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
	
func _physics_process(delta):
	var movimiento = Velocidad * delta
	var obj_colisionado = move_and_collide(movimiento)
	
	
	if(obj_colisionado != null):
		obj_colisionado = obj_colisionado.collider
		if(obj_colisionado.is_in_group("player")):
			obj_colisionado.get_parent().muerte_player()

func recibir_golpe(var id):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

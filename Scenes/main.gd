extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (PackedScene) var jugador1
export (PackedScene) var vida_j1
export (PackedScene) var jugador2
export (PackedScene) var vida_j2
export (PackedScene) var bala_comun
export (PackedScene) var bala_burbuja
export (PackedScene) var bala_abanico
export (PackedScene) var bala_laser
export (PackedScene) var bala_giratoria
export (PackedScene) var bala_enemigo
export (PackedScene) var bala_boss1
export (PackedScene) var scn_gameover
export var j1_vida = 2
export var j2_vida = 2
var j1_vidas = []
var j2_vidas = []



func _ready():
	game_handler.iniciar()
	spawn_j1()
	if(game_handler.jugadores == 2):
		spawn_j2()
	get_tree().get_nodes_in_group("camara")[0].set_limit(MARGIN_LEFT, get_tree().get_nodes_in_group("min")[0].global_position.x)
	get_tree().get_nodes_in_group("camara")[0].set_limit(MARGIN_TOP, get_tree().get_nodes_in_group("min")[0].global_position.y)
	get_tree().get_nodes_in_group("camara")[0].set_limit(MARGIN_RIGHT, get_tree().get_nodes_in_group("max")[0].global_position.x)
	get_tree().get_nodes_in_group("camara")[0].set_limit(MARGIN_BOTTOM, get_tree().get_nodes_in_group("max")[0].global_position.y)
	crear_vidas()


func respawn_j1():
	if(j1_vida > 0):
		j1_vida -= 1
		yield(get_tree().create_timer(1.0), "timeout")
		spawn_j1()
		actualizar_vidas_j1()
	else:
		var cant_jugadores = get_tree().get_nodes_in_group("player")
		if(cant_jugadores.size() < 2):
			get_tree().change_scene_to(scn_gameover)
		
func respawn_j2():
	if(j2_vida > 0):
		j2_vida -= 1
		yield(get_tree().create_timer(1.0), "timeout")
		spawn_j2()
		actualizar_vidas_j2()
	else:
		var cant_jugadores = get_tree().get_nodes_in_group("player")
		if(cant_jugadores.size() < 2):
			get_tree().change_scene_to(scn_gameover)

func spawn_j1():
	var j1 = jugador1.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(j1)
	j1.global_position = get_tree().get_nodes_in_group("spawn_j")[0].global_position
	
func spawn_j2():
	var j2 = jugador2.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(j2)
	j2.global_position = get_tree().get_nodes_in_group("spawn_j")[0].global_position
	
func crear_vidas():
	for i in j1_vida:
		var newVida = vida_j1.instance()
		j1_vidas.append(newVida)
		get_tree().get_nodes_in_group("gui")[0].add_child(newVida)
		newVida.global_position.x += i * 30
	if(game_handler.jugadores == 2):
		for i in j2_vida:
			var newVida = vida_j2.instance()
			j2_vidas.append(newVida)
			get_tree().get_nodes_in_group("gui")[0].add_child(newVida)
			newVida.global_position.x += i * 30
			
func actualizar_vidas_j1():
	j1_vidas[j1_vida].queue_free()
	
func actualizar_vidas_j2():
	j2_vidas[j2_vida].queue_free()

func agregar_vida_j1():
	j1_vida += 1
	var newVida = vida_j1.instance()
	j1_vidas.append(newVida)
	get_tree().get_nodes_in_group("gui")[0].add_child(newVida)
	newVida.global_position.x += (j1_vida-1) * 30
	
func agregar_vida_j2():
	j2_vida += 1
	var newVida = vida_j2.instance()
	j2_vidas.append(newVida)
	get_tree().get_nodes_in_group("gui")[0].add_child(newVida)
	newVida.global_position.x += (j2_vida-1) * 30
	
func seleccionar_bala(var id):
	if(id == 1):
		return bala_burbuja
	elif(id == 2):
		return bala_abanico
	elif(id == 3):
		return bala_laser
	elif(id == 4):
		return bala_giratoria
	elif(id == 5):
		return bala_comun
		



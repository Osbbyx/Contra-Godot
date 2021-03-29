extends Position2D

var Velocidad = Vector2()
export (float) var GRAVEDAD = 100
export (float) var VEL_MOVIMIENTO = 25
export (float) var VEL_SALTO = 25
var puede_disparar = true
var puede_saltar = false
var esta_en_agua = false
enum estados {idle, cuerpo_tierra, sumergido, apuntando_diagarr, apuntando_diagab, apuntando_arr, apuntando_ab, corriendo, muerto}
var suelo_inferior = false
var estado_actual = idle
var puede_agacharse = true
export (int) var arma = 0
export (PackedScene) var bala_actual
export (Vector2) var spawnB_izq
export (Vector2) var spawnB_arr
export (Vector2) var spawnB_izqAR
export (Vector2) var spawnB_izqAB

func _ready():
	spawnB_izq = get_node("cuerpo_J1/spawnbala").position
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		get_node("cuerpo_J1").add_collision_exception_with(player)
	var powerups = get_tree().get_nodes_in_group("powerup")
	for powerup in powerups:
		get_node("cuerpo_J1").add_collision_exception_with(powerup)

	
func _physics_process(delta):
	
	Velocidad.y += GRAVEDAD * delta
	
	if(estado_actual != muerto):
		
		if(Input.is_action_pressed("tecla_a") && estado_actual != cuerpo_tierra && estado_actual != sumergido):
			Velocidad.x = -VEL_MOVIMIENTO
			get_node("cuerpo_J1/spr_J1").flip_h = false
			if(Input.is_action_pressed("tecla_w")):
				if(estado_actual != apuntando_diagarr && (puede_saltar) && !esta_en_agua):
					get_node("animacion_J1").play("j1_diagarr")
					get_node("cuerpo_J1/spawnbala").position = spawnB_izqAR
					estado_actual = apuntando_diagarr
				elif(estado_actual != apuntando_diagarr && !puede_saltar):
					get_node("cuerpo_J1/spawnbala").position = spawnB_izqAR
					estado_actual = apuntando_diagarr
			elif(Input.is_action_pressed("tecla_s")):
				if(estado_actual != apuntando_diagab && (puede_saltar) && !esta_en_agua):
					get_node("animacion_J1").play("j1_diagab")
					get_node("cuerpo_J1/spawnbala").position = spawnB_izqAB
					estado_actual = apuntando_diagab
				elif(estado_actual != apuntando_diagab && !puede_saltar):
					get_node("cuerpo_J1/spawnbala").position = spawnB_izqAB
					estado_actual = apuntando_diagab
			elif(estado_actual != corriendo && (puede_saltar)):
				if(!esta_en_agua):
					get_node("animacion_J1").play("j_corriendo")
				else:
					get_node("animacion_J1").play("j1_watermove")
				estado_actual = corriendo
				get_node("cuerpo_J1/spawnbala").position = spawnB_izq
			elif(estado_actual != corriendo && !puede_saltar):
				get_node("cuerpo_J1/spawnbala").position = spawnB_izq
		elif(Input.is_action_pressed("tecla_d") && estado_actual != cuerpo_tierra && estado_actual != sumergido):
			Velocidad.x = VEL_MOVIMIENTO
			get_node("cuerpo_J1/spr_J1").flip_h = true
			if(Input.is_action_pressed("tecla_w")):
				if(estado_actual != apuntando_diagarr && (puede_saltar) && !esta_en_agua):
					get_node("animacion_J1").play("j1_diagarr")
					get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_izqAR.x * -1, spawnB_izqAR.y)
					estado_actual = apuntando_diagarr
				elif(estado_actual != apuntando_diagarr && !puede_saltar):
					get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_izqAR.x * -1, spawnB_izqAR.y)
					estado_actual = apuntando_diagarr
			elif(Input.is_action_pressed("tecla_s")):
				if(estado_actual != apuntando_diagab && (puede_saltar) && !esta_en_agua):
					get_node("animacion_J1").play("j1_diagab")
					get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_izqAB.x * -1, spawnB_izqAB.y)
					estado_actual = apuntando_diagab
				elif(estado_actual != apuntando_diagab && (!puede_saltar)):
					get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_izqAB.x * -1, spawnB_izqAB.y)
					estado_actual = apuntando_diagab
			elif(estado_actual != corriendo && (puede_saltar)):
				if(!esta_en_agua):
					get_node("animacion_J1").play("j_corriendo")
				else:
					get_node("animacion_J1").play("j1_watermove")
				estado_actual = corriendo
				get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_izq.x * -1, spawnB_izq.y)
			elif(estado_actual != corriendo && !puede_saltar):
				get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_izq.x * -1, spawnB_izq.y)
		elif(Input.is_action_pressed("tecla_w") && estado_actual != cuerpo_tierra && estado_actual != sumergido):
			if(puede_saltar && !esta_en_agua):
				get_node("animacion_J1").play("j1_haciaarriba")
				get_node("cuerpo_J1/spawnbala").position = spawnB_arr
				estado_actual = apuntando_arr
			elif(!puede_saltar):
				get_node("cuerpo_J1/spawnbala").position = spawnB_arr
				estado_actual = apuntando_arr
			Velocidad.x = 0
		elif(Input.is_action_pressed("tecla_s") && puede_agacharse):
			if(puede_saltar):
				if(!esta_en_agua):
					get_node("animacion_J1").play("j1_cuerpotierra")
					estado_actual = cuerpo_tierra
				else:
					get_node("animacion_J1").play("j1_waterunder")
					puede_disparar = false
					estado_actual = sumergido
					get_node("cuerpo_J1/colision_J1").disabled = true
			else:
				get_node("cuerpo_J1/spawnbala").position = Vector2(spawnB_arr.x, spawnB_arr.y * -1)
				estado_actual = apuntando_ab
			Velocidad.x = 0
		else:
			Velocidad.x = 0
			if(puede_saltar):
				estado_actual = idle
				if(!esta_en_agua):
					get_node("animacion_J1").play("j_idle")
					if(estado_actual == cuerpo_tierra):
						get_node("cuerpo_J1").global_position -= Vector2(0, 35)
				else:
					get_node("animacion_J1").play("j1_water")
		
		if(Input.is_action_pressed("tecla_z") && puede_saltar && estado_actual != sumergido):
			if(estado_actual != cuerpo_tierra):
				Velocidad.y = -VEL_SALTO
				get_node("animacion_J1").play("j1_salto")
				estado_actual = idle
			elif(!suelo_inferior):
				get_node("cuerpo_J1").global_position += Vector2(0, 1)
				estado_actual = idle
				get_node("animacion_J1").play("j_idle")
				
		if(Input.is_action_pressed("tecla_x") && puede_disparar):
			var newBala = get_tree().get_nodes_in_group("main")[0].seleccionar_bala(arma).instance()
			newBala.global_position = get_node("cuerpo_J1/spawnbala").global_position
			get_tree().get_nodes_in_group("main")[0].add_child(newBala)
			puede_disparar = false
			get_node("cuerpo_J1/tmr_cooldown").start()
			if(estado_actual == apuntando_arr):
				newBala.Velocidad.y = -newBala.potencia
			elif(estado_actual == idle || estado_actual == cuerpo_tierra || estado_actual == corriendo):
				if(get_node("cuerpo_J1/spr_J1").flip_h):
					newBala.Velocidad.x = newBala.potencia
				else:
					newBala.Velocidad.x = -newBala.potencia
			elif(estado_actual == apuntando_diagarr):
				if(get_node("cuerpo_J1/spr_J1").flip_h):
					newBala.Velocidad = Vector2(newBala.potencia, -newBala.potencia)
				else:
					newBala.Velocidad = Vector2(-newBala.potencia, -newBala.potencia)
			elif(estado_actual == apuntando_diagab):
				if(get_node("cuerpo_J1/spr_J1").flip_h):
					newBala.Velocidad = Vector2(newBala.potencia, newBala.potencia)
				else:
					newBala.Velocidad = Vector2(-newBala.potencia, newBala.potencia)
			elif(estado_actual == apuntando_ab && !puede_saltar):
				newBala.Velocidad.y = newBala.potencia
			
		if(Input.is_action_just_released("tecla_s") && puede_agacharse && puede_saltar):
			puede_agacharse = false
			estado_actual = idle
			get_node("animacion_J1").play("j_idle")
			global_position.y -= 35
			yield(get_tree().create_timer(0.4), "timeout")
			puede_agacharse = true
			if(get_node("cuerpo_J1/spr_J1").flip_h):
				get_node("cuerpo_J1/spawnbala").position = -spawnB_izq
			else:
				get_node("cuerpo_J1/spawnbala").position = spawnB_izq
			puede_disparar = true

				
		#ACA VOY A CALCULAR EL RESTO
		if(estado_actual != sumergido):
			var movimiento = Velocidad * delta
			get_node("cuerpo_J1").move_and_slide(movimiento)
		
		if(get_node("cuerpo_J1").get_slide_collision(get_node("cuerpo_J1").get_slide_count()-1) != null):
			var obj_colisionado = get_node("cuerpo_J1").get_slide_collision(get_node("cuerpo_J1").get_slide_count()-1).collider
			if(obj_colisionado.is_in_group("suelo")):
				get_tree().get_nodes_in_group("spawn_j")[0].global_position = get_node("cuerpo_J1").global_position
				if(obj_colisionado.is_in_group("suelo_agua")):
					suelo_inferior = true
				else:
					suelo_inferior = false
				if(puede_saltar == false):
					puede_saltar = true
					get_node("animacion_J1").stop()
					estado_actual = idle
					if(obj_colisionado.is_in_group("agua")):
						esta_en_agua = true
						get_node("animacion_J1").play("j1_water")
					else:
						esta_en_agua = false
						get_node("sfx_piso").play()
						
				if(obj_colisionado.is_in_group("puente")):
					obj_colisionado.get_parent().explotar()
			elif(obj_colisionado.is_in_group("enemigo") && estado_actual != muerto):
				muerte_player()
			elif(obj_colisionado.is_in_group("powerupabierto")):
				if(obj_colisionado.id == 6):
					agregar_vida()
				else:
					arma = obj_colisionado.id
				obj_colisionado.queue_free()
		elif(puede_saltar):
			puede_saltar = false
	else:
		var movimiento = Velocidad * delta
		get_node("cuerpo_J1").move_and_slide(movimiento)
		




func _on_tmr_cooldown_timeout():
	puede_disparar = true

func muerte_player():
	get_node("sfx_muerte").play()
	Velocidad.x = 0
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	for enemigo in enemigos:
		get_node("cuerpo_J1").add_collision_exception_with(enemigo)
	estado_actual = muerto
	get_node("animacion_J1").play("j1_muerte")
	yield(get_node("animacion_J1"), "animation_finished")
	get_tree().get_nodes_in_group("main")[0].respawn_j1()
	get_tree().get_nodes_in_group("camara")[0].global_position.x = get_node("cuerpo_J1").global_position.x
	queue_free()
	

func _on_VisibilityNotifier2D_screen_exited():
	muerte_player()
	
func agregar_vida():
	get_node("sfx_vida").play()
	get_tree().get_nodes_in_group("main")[0].agregar_vida_j1()

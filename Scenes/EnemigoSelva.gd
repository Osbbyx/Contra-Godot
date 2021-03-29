extends KinematicBody2D


enum estados {corriendo, saltando, cayendo}
var habilitado = true
export var vidas = 0
var puede_disparar = true
var angulo_final = 0
export var puntos = 0

func _ready():
	get_node("AnimationPlayer").play("apuntando_adelante")
	var powerupabiertos = get_tree().get_nodes_in_group("powerupabierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)

func _physics_process(delta):
	
	if(habilitado):
			
		var jugador_apuntado = null
		var players = get_tree().get_nodes_in_group("player")
		if(players.size() > 1):
			if(abs(players[0].global_position.x - global_position.x) < abs(players[1].global_position.x - global_position.x)):
				angulo_final = round(rad2deg((players[0].global_position - global_position).angle() / 45))
				angulo_final = deg2rad(angulo_final * 45)
			else:
				angulo_final = round(rad2deg((players[1].global_position - global_position).angle() / 45))
				angulo_final = deg2rad(angulo_final * 45)
		elif(players.size() == 1 && players[0] != null):
			angulo_final = round(rad2deg((players[0].global_position - global_position).angle() / 45))
			angulo_final = deg2rad(angulo_final * 45)		
		
		if(puede_disparar):
			puede_disparar = false
			get_node("cooldown").start()
			disparar()
			
		move_and_slide(Vector2(0,0))
		
		if(get_slide_collision(get_slide_count()-1) != null):
			var obj_colisionado = get_slide_collision(get_slide_count()-1).collider
			if(obj_colisionado != null):
				if(obj_colisionado.is_in_group("bala")):
					var padre = obj_colisionado.get_parent()
					if(padre.is_in_group("main") || padre.is_in_group("nivel")):
						recibir_golpe(obj_colisionado.id)
					else:
						recibir_golpe(padre.id)
					obj_colisionado.queue_free()
				elif(obj_colisionado.is_in_group("player")):
					obj_colisionado.get_parent().muerte_player()
				
func recibir_golpe(var id):
	vidas -= 1
	if(vidas < 1):
		muerte_enemigo()
		if(id == 1):
			game_handler.puntaje_j1 += puntos
		elif(id == 2):
			game_handler.puntaje_j2 += puntos
				
func muerte_enemigo():
	get_node("muerte").play()
	habilitado = false
	get_node("CollisionShape2D").queue_free()
	get_node("AnimationPlayer").play("explosion")
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_cooldown_timeout():
	puede_disparar = true

func disparar():
	var newBala = get_tree().get_nodes_in_group("main")[0].bala_enemigo.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(newBala)
	newBala.global_position = get_node("spawn_bala").global_position
	newBala.Velocidad.x = newBala.potencia * cos(angulo_final)
	newBala.Velocidad.y = newBala.potencia * sin(angulo_final)
	if(round(newBala.Velocidad.x) > 0 && !get_node("Sprite").flip_h):
		get_node("Sprite").flip_h = true
		get_node("spawn_bala").global_position.x = -get_node("spawn_bala").global_position.x
	elif(round(newBala.Velocidad.x) < 0 && get_node("Sprite").flip_h):
		get_node("Sprite").flip_h = false
		get_node("spawn_bala").global_position.x = -get_node("spawn_bala").global_position.x
	if(round(newBala.Velocidad.y) == 0):
		get_node("AnimationPlayer").play("apuntando_adelante")
	elif(round(newBala.Velocidad.y) < 0):
		get_node("AnimationPlayer").play("apuntando_arriba")
	elif(round(newBala.Velocidad.y) > 0):
		get_node("AnimationPlayer").play("apuntando_abajo")
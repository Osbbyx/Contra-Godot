extends KinematicBody2D

export (float) var GRAVEDAD = 100
var Velocidad = Vector2()
export (float) var VEL_MOVIMIENTO = 25
export (float) var VEL_SALTO = 25
enum estados {corriendo, saltando, cayendo}
var estado_actual = cayendo
var habilitado = true
var ultimo_punto = Vector2()
export var vidas = 0
var puede_saltar = true
export var puntos = 0

func _ready():
	get_node("AnimationPlayer").play("enem_run")
	var powerupabiertos = get_tree().get_nodes_in_group("powerupabierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)

func _physics_process(delta):
	
	if(habilitado):
		
		
		if(!get_node("Sprite").flip_h):
			Velocidad.x = -VEL_MOVIMIENTO
		else:
			Velocidad.x = VEL_MOVIMIENTO
		
		
		if(!test_move(transform, Vector2(0,1)) && estado_actual != cayendo && estado_actual != saltando && puede_saltar):
			if(rand_range(0, 10) < 4):
				estado_actual = saltando
				get_node("AnimationPlayer").play("enem_jump")
				if(Velocidad.y > 0):
					Velocidad.y = -VEL_SALTO
				puede_saltar = false
			else:
				estado_actual = cayendo
				get_node("Sprite").flip_h = !get_node("Sprite").flip_h
				Velocidad.x = 0
				global_position = ultimo_punto
				if(get_node("Sprite").flip_h):
					global_position.x += 1
				else:
					global_position.x -= 1
				puede_saltar = false
			yield(get_tree().create_timer(0.5), "timeout")
			puede_saltar = true
		else:
			Velocidad.y += GRAVEDAD * delta
			var movimiento = Velocidad * delta
			move_and_slide(movimiento)
			

			
		if(get_slide_collision(get_slide_count()-1) != null):
			var obj_colisionado = get_slide_collision(get_slide_count()-1).collider
			if(obj_colisionado != null):
				if(obj_colisionado.is_in_group("suelo")):
					if(estado_actual != corriendo):
						estado_actual = corriendo
						if(Velocidad.y >= 0):
							get_node("AnimationPlayer").play("enem_run")
						if(obj_colisionado.is_in_group("agua")):
							muerte_enemigo()
					else:
						ultimo_punto = global_position
				elif(obj_colisionado.is_in_group("bala")):
					var padre = obj_colisionado.get_parent()
					if(padre.is_in_group("main") || padre.is_in_group("nivel")):
						recibir_golpe(obj_colisionado.id)
					else:
						recibir_golpe(padre.id)
					obj_colisionado.queue_free()
				elif(obj_colisionado.is_in_group("player")):
					obj_colisionado.get_parent().muerte_player()
				elif(obj_colisionado.is_in_group("enemigo")):
					get_node("Sprite").flip_h = !get_node("Sprite").flip_h
				
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
	get_node("AnimationPlayer").play("enem_explos")
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

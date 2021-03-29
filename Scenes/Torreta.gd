extends KinematicBody2D

var torreta_abrio = false
var puede_disparar = true
export (PackedScene) var bala
export var vidas = 0
export var puntos = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
	if(torreta_abrio):
		var jugador_apuntado = null
		var players = get_tree().get_nodes_in_group("player")
		if(players.size() > 1):
			if(abs(players[0].global_position.x - get_parent().global_position.x) < abs(players[1].global_position.x - get_parent().global_position.x)):
				look_at(players[1].global_position)
				var angulo_final = round(rotation_degrees / 45)
				angulo_final = angulo_final * 45
				rotation_degrees = angulo_final
			else:
				look_at(players[0].global_position)
				var angulo_final = round(rotation_degrees / 45)
				angulo_final = angulo_final * 45
				rotation_degrees = angulo_final
		elif(players.size() == 1 && players[0] != null):
			look_at(players[0].global_position)
			var angulo_final = round(rotation_degrees / 45)
			angulo_final = angulo_final * 45
			rotation_degrees = angulo_final			
		
		if(puede_disparar):
			disparar()
			get_node("cooldown").start()
			
		if(get_slide_collision(get_slide_count()-1) != null):
			var obj_colisionado = get_slide_collision(get_slide_count()-1).collider
			if(obj_colisionado.is_in_group("bala")):
				var padre = obj_colisionado.get_parent()
				if(padre.is_in_group("main") || padre.is_in_group("nivel")):
					recibir_golpe(obj_colisionado.id)
				else:
					recibir_golpe(padre.id)
				obj_colisionado.queue_free()
			
			
func recibir_golpe(var id):
	vidas -= 1
	if(vidas < 1):
		muerte_enemigo()
		if(id == 1):
			game_handler.puntaje_j1 += puntos
		else:
			game_handler.puntaje_j2 += puntos
	else:
		get_node("golpe").play()
		
func muerte_enemigo():
	get_node("muerte").play()
	get_node("AnimationPlayer").play("explosion")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_parent().queue_free()


func disparar():
	puede_disparar = false
	var newBala = bala.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(newBala)
	newBala.global_position = get_node("Spawn_Balas").global_position
	newBala.Velocidad.x = newBala.potencia * cos(rotation)
	newBala.Velocidad.y = newBala.potencia * sin(rotation)

func _on_AnimationPlayer_animation_finished( anim_name ):
	if(anim_name == "Abriendo"):
		get_node("Arma").visible = true
		torreta_abrio = true


func _on_VisibilityNotifier2D_screen_entered():
	get_node("AnimationPlayer").play("Abriendo")


func _on_VisibilityNotifier2D_screen_exited():
	get_parent().queue_free()


func _on_cooldown_timeout():
	puede_disparar = true

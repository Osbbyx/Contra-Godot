extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (float) var GRAVEDAD = 0.0
var Velocidad = Vector2()
var id = 1


func _ready():
	randomize()
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	for enemigo in enemigos:
		add_collision_exception_with(enemigo)
	id = randi()%6+1
	get_node("AnimationPlayer").play(String(id))
	var balas = get_tree().get_nodes_in_group("bala")
	for bala in balas:
		add_collision_exception_with(bala)



func _physics_process(delta):
	Velocidad.y += GRAVEDAD * delta
	var movimiento = Velocidad * delta
	move_and_slide(movimiento)
	
	if(get_slide_collision(get_slide_count()-1) != null):
		var obj_colisionado = get_slide_collision(get_slide_count()-1).collider
		if(obj_colisionado != null):
			if(obj_colisionado.is_in_group("suelo")):
				Velocidad.x = 0
			elif(obj_colisionado.is_in_group("player")):
				if(id == 6):
					obj_colisionado.get_parent().agregar_vida()
				else:
					obj_colisionado.get_parent().arma = id
				queue_free()

				


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
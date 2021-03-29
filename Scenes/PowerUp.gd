extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var habilitado = false
var Velocidad = Vector2()
export var vel_movimiento = 10
export (PackedScene) var powerup_abierto
var delta_t = 0

func _ready():
	Velocidad.x -= vel_movimiento

func _physics_process(delta):
	if(habilitado):
		delta_t += delta
		Velocidad.y = cos(delta_t * 3) * 3000
		var movimiento = Velocidad * delta
		move_and_slide(movimiento)
		
		if(get_slide_collision(get_slide_count()-1) != null):
			var obj_colisionado = get_slide_collision(get_slide_count()-1).collider
			if(obj_colisionado != null && obj_colisionado.is_in_group("bala")):
				explotar()
			
		

func explotar():
	get_node("muerte").play()
	var powerup_new = powerup_abierto.instance()
	powerup_new.global_position = global_position
	powerup_new.Velocidad = Velocidad
	get_tree().get_nodes_in_group("nivel")[0].add_child(powerup_new)
	get_node("AnimationPlayer").play("explosion")
	habilitado = false
	get_node("CollisionShape2D").queue_free()
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	habilitado = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

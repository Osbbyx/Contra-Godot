extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var habilitado = false
export var vel_explosion = Vector2()
export (PackedScene) var powerup_abierto

func _ready():
	pass

func _physics_process(delta):
	if(habilitado):
		get_node("AnimationPlayer").play("movimiento")
		habilitado = false
			
		

func explotar():
	var powerup_new = powerup_abierto.instance()
	powerup_new.global_position = global_position
	powerup_new.Velocidad = vel_explosion
	get_tree().get_nodes_in_group("nivel")[0].add_child(powerup_new)
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	habilitado = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

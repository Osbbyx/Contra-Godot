extends Node

var explotando = false

func _ready():

	pass

func _physics_process(delta):
	pass
	
func explotar():
	if(!explotando):
		explotando = true
		yield(get_tree().create_timer(0.5), "timeout")
		get_node("explosion").play()
		get_node("Puente/AnimationPlayer").play("explosion")
		get_node("AreaExplosion/CollisionShape2D").disabled = false
		yield(get_node("Puente/AnimationPlayer"), "animation_finished")
		get_node("Puente").queue_free()
		get_node("AreaExplosion/CollisionShape2D").disabled = true
		yield(get_tree().create_timer(0.5), "timeout")
		get_node("explosion").play()
		get_node("Puente2/AnimationPlayer").play("explosion")
		get_node("AreaExplosion2/CollisionShape2D").disabled = false
		get_node("Puente2/CollisionShape2D").queue_free()
		yield(get_node("Puente2/AnimationPlayer"), "animation_finished")
		get_node("Puente2").queue_free()
		get_node("AreaExplosion2/CollisionShape2D").disabled = true
		yield(get_tree().create_timer(0.5), "timeout")
		get_node("explosion").play()
		get_node("Puente3/AnimationPlayer").play("explosion")
		get_node("AreaExplosion3/CollisionShape2D").disabled = false
		get_node("Puente3/CollisionShape2D").queue_free()
		yield(get_node("Puente3/AnimationPlayer"), "animation_finished")
		get_node("Puente3").queue_free()
		queue_free()



func _on_AreaExplosion_body_entered( body ):
	detectar_enemigo(body)


func _on_AreaExplosion2_body_entered( body ):
	detectar_enemigo(body)


func _on_AreaExplosion3_body_entered( body ):
	detectar_enemigo(body)
	
func detectar_enemigo(var body):
	if(body.is_in_group("enemigo") && !body.is_in_group("bala_enemigo")):
		body.recibir_golpe(3)


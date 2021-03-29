extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var opcion_actual = 1
export (PackedScene) var juego

func _ready():
	pass

func _physics_process(delta):
	if(Input.is_action_just_pressed("tecla_start")):
		empezar()
	elif(Input.is_action_just_pressed("tecla_select")):
		cambiar_opcion()
		
func cambiar_opcion():
	if(opcion_actual == 1):
		opcion_actual = 2
	else:
		opcion_actual = 1
		
	if(opcion_actual == 1):
		get_node("GUI/Menu/cursor").global_position = get_node("GUI/Menu/1p").global_position
	else:
		get_node("GUI/Menu/cursor").global_position = get_node("GUI/Menu/2p").global_position
		
func empezar():
	for i in 8:
		get_node("GUI/AnimationPlayer2").play("parpadear")
		yield(get_node("GUI/AnimationPlayer2"), "animation_finished")
	get_tree().change_scene_to(juego)
	game_handler.jugadores = opcion_actual

func _on_AnimationPlayer_animation_finished( anim_name ):
	get_node("AudioStreamPlayer").play()


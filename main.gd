extends Node

@export var pipe_scene : PackedScene

const VEL_DESP : int = 5
const RETARD_TUBERIAS : int = 100
const ESPAI_TUBERIAS : int = 200
var joc_actiu : bool
var joc_acabat : bool
var desplaçament_fons
var puntuació_jugador
var mida_pantalla : Vector2i
var alçada_terra : int
var tuberias : Array

func _ready():
	mida_pantalla = get_window().size
	alçada_terra = $Suelo.get_node("Sprite2D").texture.get_height()
	novaPartida()

func novaPartida():
	joc_actiu = false
	joc_acabat = false
	puntuació_jugador = 0
	desplaçament_fons = 0
	$Puntuacio.text = "PUNTUACIÓ: " + str(puntuació_jugador)
	$GameOver.hide()
	get_tree().call_group("tuberias", "queue_free")
	tuberias.clear()
	generar_tuberies()
	$berb.reset()
	
func _input(event):
	if joc_acabat == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if joc_actiu == false:
					iniciar_joc()
				else:
					if $berb.volant:
						$berb.flap()
						comprovar_top()

func iniciar_joc():
	joc_actiu = true
	$berb.volant = true
	$berb.flap()
	$TuberiasTimer.start()

func _process(delta):
	if joc_actiu:
		desplaçament_fons += VEL_DESP
		if desplaçament_fons >= mida_pantalla.x:
			desplaçament_fons = 0
		$Suelo.position.x = -desplaçament_fons
		for pipe in tuberias:
			pipe.position.x -= VEL_DESP

func _on_tuberias_timer_timeout():
	generar_tuberies()
	
func generar_tuberies():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = mida_pantalla.x + ESPAI_TUBERIAS
	pipe.position.y = (mida_pantalla.y - alçada_terra) / 2  + randi_range(-RETARD_TUBERIAS, RETARD_TUBERIAS)
	pipe.tocat.connect(bird_hit)
	pipe.sumaPunt.connect(sumarPunts)
	add_child(pipe)
	tuberias.append(pipe)
	
func sumarPunts():
	puntuació_jugador += 1
	$Puntuacio.text = "PUNTUACIÓ: " + str(puntuació_jugador)

func comprovar_top():
	if $berb.position.y < 0:
		$berb.caient = true
		aturar_joc()

func aturar_joc():
	$TuberiasTimer.stop()
	$GameOver.show()
	$berb.volant = false
	joc_actiu = false
	joc_acabat = true
	
func bird_hit():
	$berb.caient = true
	aturar_joc()

func _on_suelo_tocat():
	$berb.caient = false
	aturar_joc()

func _on_game_over_restart():
	novaPartida()

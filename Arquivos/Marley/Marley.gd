extends KinematicBody2D

var velocidade_geral = Vector2(500,900)
export var movimento = Vector2.ZERO
export var gravidade_geral = 4500
export var vidas = 7
var permite_duplo = true
onready var player = $"."
onready var teste = $Area2D
export onready var teste1 = $Timer

func _physics_process(delta : float) -> void :
	#teste1.start(10)
	#print(teste1.time_left)
	#teste.emit_signal("area_entered")
	verifica_vidas()
	if player.visible:
		var direcao = calcular_direcao()
		movimento = calcular_movimento(movimento, direcao ,velocidade_geral)
		movimento = move_and_slide(movimento, Vector2.UP)

func calcular_direcao() -> Vector2:
	
	var direcao := Vector2((Input.get_action_strength("mover_direita")
	-Input.get_action_strength("mover_esquerda")), -1.0 
	if Input.get_action_strength("mover_cima") and is_on_floor() else 1.0)
	return direcao
	
func calcular_movimento(
		linear : Vector2,
		direcao : Vector2,
		velocidade : Vector2) -> Vector2:

	if is_on_floor():
		permite_duplo = true
	
	var nova_velocidade := linear
	nova_velocidade.x = velocidade.x * direcao.x
	nova_velocidade.y += gravidade_geral * get_physics_process_delta_time()
	
	if direcao.y == -1:
		nova_velocidade.y = velocidade.y * direcao.y
	
	if Input.get_action_strength("mover_baixo"):
		nova_velocidade.y = velocidade.y * 2
	
	if Input.is_action_just_pressed("mover_cima") and is_on_floor() == false and permite_duplo == true:
		nova_velocidade.y = velocidade.y * -1
		permite_duplo = false
	
	return nova_velocidade;

func verifica_vidas():
	if vidas == 0:
		player.hide()

func is_visible() -> bool:
	return player.visible

func _on_Area2D_area_entered(area):
	if area.get_name() == "Area2D":
		velocidade_geral.x = 2000
	if area.get_name() == "BossArea":
		player.hide()
	
	#if area.get_name() == "RexArea":
		
		#if teste1.wait_time == 0:
			#teste1.wait_time = 2
			
			#vidas -= 1

extends Node3D 

var t = 0
@export var speed = 0.5
@export var minXPosition = -10
@export var maxXPosition = 10
@export var start_position = Vector3(-18, 3, -22)
@export var end_position = Vector3(-18, 3, -4)

var wallList = []

# Se llama cuando el nodo entra al árbol  por primera vez.
func _ready() -> void:
	
	wallList.append($AnimatableBody3D/CSGPolygon3D)
	wallList.append($AnimatableBody3D/CSGPolygon3D2)
	wallList.append($AnimatableBody3D/CSGPolygon3D3)
	wallList.append($AnimatableBody3D/CSGPolygon3D4)
	wallList.append($AnimatableBody3D/CSGPolygon3D5)
	aparecerMuroAleatorio()
	global_transform.origin = start_position  # Coloca el muro en la posicion inicial

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(delta: float) -> void:
	t += delta * speed
 # Variable para mover
	global_transform.origin = lerp(start_position,end_position,t)  # Actualiza la posición del muro, moviendolo
	
	
	#Detectar si colisiona con el personaje
	
	
	# Si el muro alcanza la posición final, se elimina
	if t >= 1:
		speed += 0.03
		get_parent().call("incremetarPuntos")
		aparecerMuroAleatorio()
		t = 0
		  # Si quiero eliminar el muro puedo utilizar ""queue_free()"

func aparecerMuroAleatorio():
	#elije una posicion aleatoria horizontal
	var randomXPosition = randf_range(minXPosition,maxXPosition)
	start_position.x = randomXPosition
	end_position.x = randomXPosition
	#desabilita las demas formas de muros para evitar conflictos
	desabilitarTodosLosMuros()
	#elije una forma para habilitar
	var randomWall = wallList.pick_random()
	randomWall.visible = true
	randomWall.use_collision = true
	
func desabilitarTodosLosMuros():
	for wall in wallList:
		wall.visible = false
		wall.use_collision = false

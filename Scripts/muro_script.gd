extends Node3D 

var t = 0
@export var speed = 0.5
@export var start_position = Vector3(-18, 3, -22)
@export var end_position = Vector3(-18, 3, -4)


# Se llama cuando el nodo entra al árbol  por primera vez.
func _ready() -> void:
	global_transform.origin = start_position  # Coloca el muro en la posicion inicial

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(delta: float) -> void:
	t += delta * speed
 # Variable para mover
	global_transform.origin = lerp(start_position,end_position,t)  # Actualiza la posición del muro, moviendolo
	
	
	#Detectar si colisiona con el personaje
	
	
	# Si el muro alcanza la posición final, se elimina
	if t >= 1:
		t = 0
		  # Si quiero eliminar el muro puedo utilizar ""queue_free()"

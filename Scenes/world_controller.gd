extends Node3D

var puntos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("puntos").text = "Puntos: " + str(puntos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func incremetarPuntos():
	puntos += 100
	get_node("puntos").text = "Puntos: " + str(puntos)

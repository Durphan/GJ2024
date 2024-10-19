extends CharacterBody3D

#Este scrip tiene que estar en el scrip del player
#dentro tiene que tener un Area3D y este Area3D un hijo CollisionShape3D
#Player
# |_Area3D
#   |_ CollisionShape3D  
func _ready():
	#Conectar la señal de colision para detectar la colision con la pared
	$Area3D.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	#verifica si el cuerpo con el que colisiona es una pared
	if body.is_in_group("Pared"): #La pared con la que choca tiene que estar en un grupo llamado Pared
		game_over()

func game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

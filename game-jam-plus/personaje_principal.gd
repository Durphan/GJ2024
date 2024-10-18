extends Node3D

@export var speed = 14
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var ColummnPosition = 0
var brazoDerechoPosition = 0
var brazoIzquierdoPosition = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	columna(delta)
	brazoDerecho(delta)
	brazoIzquierdo(delta)
	
func columna(delta:float):
	if Input.is_action_pressed("columnaDerecha"):
		ColummnPosition -= 1 * delta
	if Input.is_action_pressed("columnaIzquierda"):
		ColummnPosition += 1 * delta
		
	ColummnPosition = clampf(ColummnPosition,-1,1)
	$Armature/Skeleton3D.set_bone_pose_rotation(1,Quaternion(-0.051,0,ColummnPosition,0.998))
	
func brazoDerecho(delta:float):
	if Input.is_action_pressed("brazo derecho derecha"):
		brazoDerechoPosition += 5 * delta
	if Input.is_action_pressed("brazo derecho izquierda"):
		brazoDerechoPosition -= 5 * delta
		
	brazoDerechoPosition = clampf(brazoDerechoPosition,-4,1.3)
	$Armature/Skeleton3D.set_bone_pose_rotation(8,Quaternion(brazoDerechoPosition,0.003,0.012,3.247))
	
func brazoIzquierdo(delta:float):
	if Input.is_action_pressed("brazo izquierdo derecha"):
		brazoIzquierdoPosition += 1 * delta
	if Input.is_action_pressed("brazo izquierdo izquierda"):
		brazoIzquierdoPosition -= 1 * delta
		
	brazoIzquierdoPosition = clampf(brazoIzquierdoPosition,-1,0.5)
	$Armature/Skeleton3D.set_bone_pose_rotation(32,Quaternion(brazoIzquierdoPosition,-0.005,-0.012,0.992))

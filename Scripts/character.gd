extends Node3D

var ColummnPosition = 0
var brazoDerechoPosition = 0
var brazoIzquierdoPosition = 0

# movement/walking/jumping stuff
const JUMP_STRENGTH = 70
const SPEED = 100
const DAMPING = 0.9

@onready var on_floor_left = $"Physical/Armature/Skeleton3D/Physical Bone LLeg2/OnFloorLeft" # shapecast on the feet to check if its on floor
@onready var on_floor_right = $"Physical/Armature/Skeleton3D/Physical Bone RLeg2/OnFloorRight" # shapecast on the feet to check if its on floor
@onready var jump_timer = $Physical/JumpTimer # timer to stop excidental double jump
var can_jump = true
var is_on_floor = false
var walking = false # if it is walking


# spring stuff
@export var angular_spring_stiffness: float = 4000.0
@export var angular_spring_damping: float = 80.0
@export var max_angular_force: float = 9999.0

var physics_bones = [] # all physical bones

# turn it into ragdoll
@export var ragdoll_mode := false


@onready var physical_skel : Skeleton3D = $Physical/Armature/Skeleton3D
@onready var animated_skel : Skeleton3D = $Animated/Armature/Skeleton3D
@onready var physical_bone_body : PhysicalBone3D = $"Physical/Armature/Skeleton3D/Physical Bone Body"




var current_delta:float

#en resumen tenemos dos esqueletos uno fisico y otro animado
#el esqueleto fisico sigue los movimientos del animado pero puede ser empujado
#no se puede utilizar character body por que necesita un esqueleto fisico

func _ready():
	physical_skel.physical_bones_start_simulation()# activa el ragdoll para que las fisicas afecten al esqueleto
	physics_bones = physical_skel.get_children().filter(func(x): return x is PhysicalBone3D) # guarda los huesos fisicos para poder moverlos
	

func _input(_event):
	if Input.is_action_just_pressed("ragdoll"): ragdoll_mode = bool(1-int(ragdoll_mode)) # activa el modo ragdoll de toda la vida

func _physics_process(delta):
	current_delta = delta
	if not ragdoll_mode:# si no esta en modo ragdoll completamente
		#estas funciones mueven los brazos
		brazoDerecho(delta)
		brazoIzquierdo(delta)
		
		# walking control
		walking = false
		var dir = Vector3.ZERO
		if Input.is_action_pressed("move_left"):
			dir += animated_skel.global_transform.basis.x
			walking = true
		if Input.is_action_pressed("move_right"):
			dir -= animated_skel.global_transform.basis.x
			walking = true
		dir = dir.normalized()

		physical_bone_body.linear_velocity += dir*SPEED*delta #move character
		physical_bone_body.linear_velocity *= Vector3(DAMPING,1,DAMPING)# add damping to make it less slippery
		
		
		#detecta el suelo con shape cast
		is_on_floor = false
		if on_floor_left.is_colliding():
			for i in on_floor_left.get_collision_count():
				if on_floor_left.get_collision_normal(i).y > 0.5:
					is_on_floor = true
					break
		if not is_on_floor: 
			if on_floor_right.is_colliding():
				for i in on_floor_right.get_collision_count():
					if on_floor_right.get_collision_normal(i).y > 0.5:
						is_on_floor = true
						break
		
		#salta
		if Input.is_action_pressed("jump"):
			if is_on_floor and can_jump:
				physical_bone_body.linear_velocity.y += JUMP_STRENGTH
				jump_timer.start()
				can_jump = false

#usa la Ley de elasticidad de Hooke para devolver la fuerza necesaria para mover los huesos fisicos
func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, damping: float) -> Vector3:
	return (stiffness * displacement) - (damping * current_velocity)


func _on_jump_timer_timeout():
	# jump timer to avoid spamming jump and then fly away
	can_jump = true


func _on_skeleton_3d_skeleton_updated() -> void:
	if not ragdoll_mode:# if not in ragdoll mode
		# rota los huesos fisicos como los animados, no modifica su posicion
		for bone:PhysicalBone3D in physics_bones:
			var target_transform: Transform3D = animated_skel.global_transform * animated_skel.get_bone_global_pose(bone.get_bone_id())
			var current_transform: Transform3D = physical_skel.global_transform * physical_skel.get_bone_global_pose(bone.get_bone_id())
			var rotation_difference: Basis = (target_transform.basis * current_transform.basis.inverse())
			var torque = hookes_law(rotation_difference.get_euler(), bone.angular_velocity, angular_spring_stiffness, angular_spring_damping)
			torque = torque.limit_length(max_angular_force)
			
			bone.angular_velocity += torque * current_delta

func brazoDerecho(delta:float):
	if Input.is_action_pressed("brazo derecho derecha"):
		brazoDerechoPosition -= 1 * delta
	if Input.is_action_pressed("brazo derecho izquierda"):
		brazoDerechoPosition += 1 * delta
		
	brazoDerechoPosition = clampf(brazoDerechoPosition,-0.8,0.8)
	$Animated/Armature/Skeleton3D.set_bone_pose_rotation(6,Quaternion(brazoDerechoPosition,0,0,1))
	
func brazoIzquierdo(delta:float):
	if Input.is_action_pressed("brazo izquierdo derecha"):
		brazoIzquierdoPosition += 1 * delta
	if Input.is_action_pressed("brazo izquierdo izquierda"):
		brazoIzquierdoPosition -= 1 * delta
		
	brazoIzquierdoPosition = clampf(brazoIzquierdoPosition,-0.8,0.8)
	$Animated/Armature/Skeleton3D.set_bone_pose_rotation(2,Quaternion(0,0,brazoIzquierdoPosition,1))

func game_over():
	print("game over")
	get_tree().call_deferred("change_scene_to_file","res://Scenes/game_over.tscn")


func _on_character_area_area_entered(area: Area3D) -> void:
	print(area.name)
	if area.name == "pileta":
		game_over()

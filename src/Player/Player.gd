extends KinematicBody2D

export var speed := 400.0
export var accel := 2000.0

export var jump_force := 700.0
export var max_jumps := 1
var jumps_remaining := 1
var jump_if_psoible := false

export var gravity := 250.0
var max_gravity_force := 1000.0
export var wall_speed := 100.0
export var wall_force := 400.0

var velocity := Vector2.ZERO

onready var jump_buffer_timer:Timer= $JumpBuffer
onready var right_raycast:RayCast2D = $RightCast
onready var left_raycast:RayCast2D = $LeftCast

func _physics_process(delta):
	var x_input = get_horizontal_input()
	set_horizontal_movement(x_input, delta)
	
	apply_gravity(delta)
	jump()
	
	velocity = move_and_slide(velocity, Vector2.UP)

func get_horizontal_input():
	var input_dir = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	
	if abs(input_dir) < 0.2:
		return 0
	
	return input_dir

func set_horizontal_movement(input:float, delta:float):
	var target_speed = input*speed
	velocity.x = move_toward(velocity.x, target_speed, accel*delta)

func apply_gravity(delta:float):
	velocity.y += pow(gravity * delta, 2)
	
	if is_on_wall() and velocity.y > wall_speed:
		velocity.y = wall_speed
	
	velocity.y = clamp(velocity.y, -max_gravity_force, max_gravity_force)


func jump():
	if is_on_floor() and jumps_remaining != max_jumps or is_on_wall() and jumps_remaining != max_jumps:
		jumps_remaining = max_jumps
	
	if Input.is_action_just_pressed("jump"):
		jump_if_psoible = true
		jump_buffer_timer.start()
	
	if jump_if_psoible and jumps_remaining > 0:
		jumps_remaining -= 1
		velocity.y = -jump_force
		
		if !is_on_floor() and is_on_wall():
			if right_raycast.is_colliding():
				velocity.x = -wall_force
			elif left_raycast.is_colliding():
				velocity.x = wall_force
		
		jump_if_psoible = false
	
	if !Input.is_action_pressed("jump") and velocity.y < -jump_force/2:
		velocity.y = -jump_force/2

func _on_JumpBuffer_timeout() -> void:
	jump_if_psoible = false

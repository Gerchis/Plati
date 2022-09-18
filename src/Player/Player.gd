extends KinematicBody2D

export var speed := 400.0
export var accel := 2000.0
export var jump_force := 600.0
export var max_jumps := 2
var jumps_remaining := 2
export var gravity := 800.0
var max_gravity_force := 1000.0

var velocity := Vector2.ZERO

func _physics_process(delta):
	var x_input = get_horizontal_input()
	set_horizontal_movement(x_input, delta)
	
	apply_gravity(delta)
	jump()
	
	velocity = move_and_slide(velocity, Vector2.UP)

func get_horizontal_input():
	return Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")

func set_horizontal_movement(input:float, delta:float):
	var target_speed = input*speed
	velocity.x = move_toward(velocity.x, target_speed, accel*delta)

func apply_gravity(delta:float):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -max_gravity_force, max_gravity_force)

func jump():
	if is_on_floor() and jumps_remaining != max_jumps:
		jumps_remaining = max_jumps
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force

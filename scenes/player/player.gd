extends CharacterBody2D
class_name Player

@export var speed:float = 100.0
@export var jump_speed:float = 250.0

func _physics_process(delta: float) -> void:

	var gravity = get_gravity()
	up_direction = -1 * gravity.normalized() if gravity else Vector2.DOWN
	if not is_on_floor():
		velocity += gravity * delta


	if up_direction.x == 0:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_speed * up_direction.y

		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	elif up_direction.y == 0:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.x = jump_speed * up_direction.x

		var direction := Input.get_axis("move_up", "move_down")
		if direction:
			velocity.y = direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

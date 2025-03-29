extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 400.0


func _physics_process(delta: float) -> void:

	var gravity = get_gravity()
	up_direction = -1 * gravity.normalized() if gravity else Vector2.DOWN
	if not is_on_floor():
		velocity += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * up_direction.y

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

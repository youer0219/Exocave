class_name Rigidbody2DPusher
extends Node2D
## 来自：https://chris-tutorials.itch.io/grid-building-godot
## Adds forces to Rigidbody2Ds in collision with the CharacterBody2D root
## based on the velocity direction of the CharacterBody2D

@export var body : CharacterBody2D
@export_range(0.0, 1000.0, .5, "or_greater") var force_per_second : float = 80000.0

func _physics_process(delta: float) -> void:
	var collision_count = body.get_slide_collision_count()
	
	for index in range(0, collision_count, 1):
		var collision : KinematicCollision2D = body.get_slide_collision(index)
		var collider : Object = collision.get_collider()
		
		if collider is RigidBody2D:
			var push_direction = body.global_position.direction_to(collider.global_position)
			var force_vector = force_per_second * delta * push_direction
			collider.apply_force(force_vector)

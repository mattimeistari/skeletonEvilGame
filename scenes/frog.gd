extends CharacterBody2D

# Create variables
var player
var chase = false
var SPEED = 60
var JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("idle")

func _physics_process(delta):
	# Frog movement
	velocity.y += gravity * delta
	
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("jump")
			player = get_node("../../player/player")
			
			var direction = (player.position - self.position).normalized()
			if direction.x > 0:
				# right
				get_node("AnimatedSprite2D").flip_h = true
			else:
				# left
				get_node("AnimatedSprite2D").flip_h = false
				
			velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
			velocity.x = 0
		
		
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "player":
		chase = false





func _on_player_death_body_entered(body):
	if body.name == "player":
		chase = false
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
		
		self.queue_free()

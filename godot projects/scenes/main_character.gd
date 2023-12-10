extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var slime_in_range=false
func _physics_process(delta):
	if slime_in_range==true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"main")
			return
	#animation walking
	if(velocity.x>1 || velocity.x<-1):
		sprite_2d.animation="running"
	else:
		sprite_2d.animation="default"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation="jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	move_and_slide()
	
	var isLeft = velocity.x<0
	sprite_2d.flip_h=isLeft
	



	


func _on_detectionarea_body_entered(body):
	if body.has_method("enemy"):
		slime_in_range=true
	

func _on_detectionarea_body_exited(body):
	if body.has_method("enemy"):
		slime_in_range=false
	
	

extends CharacterBody2D

@onready var sprite_node = get_node("AnimatedSprite2D")

#constantes de animação
const ANIM_IDLE = 'idle'
const ANIM_RUN = 'run'

#Variaveis de animacao
var animacao = ANIM_IDLE
var nova_animacao = animacao 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	sprite_node.play(animacao)
	pass

func _physics_process(delta):
	if nova_animacao != animacao:
			animacao = nova_animacao
			sprite_node.play(animacao)
	
	#atualizar a animação de caminhada
	if velocity.x != 0.0:
		#personagem esta correndo 
		nova_animacao = ANIM_RUN
	else:
		nova_animacao = ANIM_IDLE
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			sprite_node.flip_h = true
		else:
			sprite_node.flip_h = false 
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

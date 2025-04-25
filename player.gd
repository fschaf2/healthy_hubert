extends CharacterBody2D

const max_speed=120
const x_accel=10
const x_decel=30
const x_friction=10
const gravity=15
const jump_speed=180
const max_jump_frames=15
var jump_frames=0
var buffer_jump=false
var spraying=false
var sanitizer_health=100

func _physics_process(delta: float) -> void:
	velocity.y+=gravity
	if(Input.is_action_just_pressed("Jump")):
		if (is_on_floor()):
			start_jumping()
		elif (velocity.y>0):
			buffer_jump=true
	if (buffer_jump):
		if (is_on_floor()):
			start_jumping()
	if (Input.is_action_just_released("Jump")):
		jump_frames=0
		buffer_jump=false
	if (Input.is_action_pressed("Jump") and jump_frames>0):
		velocity.y=-jump_speed
		jump_frames-=1
		buffer_jump=false
	handle_x_input(Input.get_axis("Move_Left","Move_Right"))
	move_and_slide()
	if (Input.is_action_just_pressed("Spray_Sanitizer")):
		$Sprite2D/SanitizerParticles.emitting=true
		$Sprite2D/SanitizerSpray.enabled=true
		spraying=true
		#$SanitizerAudio.play()
	if (spraying and Input.is_action_just_released("Spray_Sanitizer")):
		$Sprite2D/SanitizerParticles.emitting=false
		$Sprite2D/SanitizerSpray.enabled=false
		spraying=false
		$SanitizerAudio.stop()
	if (spraying):
		sanitizer_health-=1
	if ($Sprite2D/SanitizerSpray.is_colliding()):
		if $Sprite2D/SanitizerSpray.get_collider()!=null:
			$Sprite2D/SanitizerSpray.get_collider().queue_free()
		
	if (is_on_floor()):
		if (abs(get_real_velocity().x)<9):
			$Sprite2D/AnimationPlayer.current_animation="idle"
		else:
			$Sprite2D/AnimationPlayer.current_animation="walking"
	else:
		$Sprite2D/AnimationPlayer.current_animation="jumping"
	if (abs(get_real_velocity().x)>=9):
		$Sprite2D.scale=Vector2(sign(get_real_velocity().x),1)
	
func handle_x_input(axis):
	if (sign(axis) == sign(velocity.x)):
		velocity.x+=x_accel*sign(velocity.x)
	elif (sign(axis)==-sign(velocity.x)):
		velocity.x-=x_decel*sign(velocity.x)
	elif (velocity.x==0):
		velocity.x+=x_accel*sign(axis)
	else:
		if (sign(velocity.x-(x_friction*sign(velocity.x)))==sign(velocity.x)):
			velocity.x-=(x_friction*sign(velocity.x))
		else:
			velocity.x=0
	velocity.x=clamp(velocity.x,-max_speed,max_speed)

func start_jumping():
	jump_frames=max_jump_frames
	buffer_jump=false
	#$JumpSound.play()
	

func die():
	queue_free()

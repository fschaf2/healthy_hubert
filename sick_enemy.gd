extends CharacterBody2D
var speed=60
var sneezing=false
var can_sneeze=true
var about_to_sneeze=false
var gender
var sneezy_time=0.5
func _ready():
	if (randi_range(0,1)==1):
		var image=Image.load_from_file("res://sickwoman.png")
		$Sprite2D.texture=ImageTexture.create_from_image(image)
		$SneezeSound.stream=AudioStreamWAV.load_from_file("res://alliesneeze.wav")
		sneezy_time=0.3
func _physics_process(delta: float):
	velocity.y+=15
	velocity.x=speed
	if(is_on_floor() and velocity.y==15):
		$Sprite2D/AnimationPlayer.speed_scale=0.5
		$Sprite2D/AnimationPlayer.current_animation="eiosjsoid/walking"
		if ($JumpChecker.is_colliding()):
			jump()
	if ($Turnaround.is_colliding()):
		turn_around()
	move_and_slide()
	if ($SneezeCast.is_colliding()):
		if (sneezing):
			if ($SneezeCast.get_collider()!=null):
				$SneezeCast.get_collider().die()
			sneezing=false
		elif (can_sneeze):
			$SneezeCast.enabled=false
			$SneezeSound.play()
			$SneezeTimer.start(sneezy_time)
			can_sneeze=false
			$SneezeCooldown.start()
			about_to_sneeze=true
		
		
func turn_around():
	scale.x*=-1
	speed*=-1
	$SneezeParticles.gravity=Vector2(sign(speed)*-500,0)
	
	
func lead_to_death():
	pass
	#$Turnaround.enabled=false
	#set_collision_mask_value(7,false)
	#set_collision_layer_value(6,false)
func jump():
	velocity.y=-300
	$Sprite2D/AnimationPlayer.speed_scale=1
	$Sprite2D/AnimationPlayer.current_animation="eiosjsoid/jumping"

func _on_sneeze_timer_timeout() -> void:
	if (about_to_sneeze):
		$SneezeCast.enabled=true
		sneezing=true
		about_to_sneeze=false
		$SneezeParticles.emitting=true
		$SneezeTimer.start(sneezy_time)
	else:
		sneezing=false
		$SneezeParticles.emitting=false


func _on_sneeze_cooldown_timeout() -> void:
	can_sneeze=true


func _on_dice_roll_timer_timeout() -> void:
	if (is_on_floor()):
		var randy=randi_range(1,10)
		if ((randy==3 or randy==4) and !sneezing and (global_position.x<426) and (global_position.x>0)):
			turn_around()
		if (randy==5):
			jump()

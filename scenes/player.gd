extends KinematicBody


var speed : float = 20.0
var strafeSpeed : float = 10
var flame = false


var max_turn_clamp = 10

onready var camera = get_node("Camera")
onready var body = get_node("body")
onready var eyes = get_node("eyes")


func _physics_process(delta):
	var velocity = Vector3(0,0,0)
	
	#ok_at(get_global_mouse_pos())
	if Input.is_action_pressed("forward"):
		velocity.z -= speed

	if Input.is_action_pressed("s_left"):
		velocity.x -= strafeSpeed
	if Input.is_action_pressed("s_right"):
		velocity.x += strafeSpeed
	if Input.is_action_pressed("shoot"):
		flame = true
	else:
		flame = false
	
	if flame:
		$eyes/flame/Particles.emitting = true
		$eyes/flame/OmniLight.light_energy = 2
		$eyes/flame/SpotLight.light_energy = 2
	else:
		$eyes/flame/Particles.emitting = false
		$eyes/flame/OmniLight.light_energy = 0
		$eyes/flame/SpotLight.light_energy = 0
	lookAtMouse()
	
	
	#$body.rotation = lerp($body.rotation, $eyes.rotation, .5)
	
	move_and_slide(velocity.rotated(Vector3(0, 1, 0), body.rotation.y), Vector3.UP, true)


func lookAtMouse():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var rayOrigin = camera.project_ray_origin(mouse_pos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos) * 2000
	
	var intersection = get_world().direct_space_state.intersect_ray(rayOrigin, rayEnd)
	
	if !(intersection.empty()):
		var intersection_pos = intersection.position
		var look_at_object = Vector3(intersection_pos.x, translation.y, intersection_pos.z)
		body.look_at(look_at_object, Vector3(0,1,0))
		eyes.look_at(intersection_pos, Vector3(0,1,0))
	#print(rayOrigin)



func _on_flame_body_entered(body):
	if body.is_in_group("flamable"):
		body.inflame()

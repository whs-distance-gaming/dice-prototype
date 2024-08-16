extends RigidBody3D

var is_rolling = false
var first_roll = true
signal roll_finished(value)
@onready var raycasts = $Raycasts.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_accept") && sleeping:
		randomize()
		_roll_dice()

func _roll_dice():
	sleeping = false
	var random_number = randi_range(-50,50)
	while random_number < 20 and random_number > -20:
		random_number = randi_range(-50, 50)
	var random_force = Vector3(random_number, random_number, random_number)
	var random_torque = Vector3(random_number, random_number, random_number)
	
	apply_impulse(Vector3(), random_force)
	apply_torque_impulse(random_torque)
	is_rolling = true
	first_roll = false

func _on_sleeping_state_changed():
	if sleeping && !first_roll:
		for raycast in raycasts:
			if raycast.is_colliding():
				roll_finished.emit(raycast.opposite_side)

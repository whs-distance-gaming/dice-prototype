extends RigidBody3D

var is_rolling = false
var first_roll = true
var value
signal roll_finished(values)
@onready var raycasts = $Raycasts.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_accept") and sleeping:
		randomize()
		roll_dice()
		
func _on_button_roll_pressed() -> void:
	var dices = get_parent().dice_list
	if sleeping:
		randomize()
		for dice in dices:
			dice.roll_dice()

func roll_dice():
		sleeping = false
		var random_force = get_random_force(-60, 60)
		var random_torque = get_random_force(-60, 60)
		apply_impulse(Vector3(), random_force)
		apply_torque_impulse(random_torque)
		is_rolling = true
		first_roll = false

func get_random_force(min_value: float, max_value: float) -> Vector3:
	var force = Vector3(
		randi_range(min_value, max_value), 
		randi_range(min_value, max_value), 
		randi_range(min_value, max_value)
	)
	while force.length() < 20:
		force = Vector3(
			randi_range(min_value, max_value), 
			randi_range(min_value, max_value), 
			randi_range(min_value, max_value)
		)
	return force


func _on_sleeping_state_changed():
	if sleeping && !first_roll:
		for raycast in raycasts:
			value = raycast.opposite_side
			if raycast.is_colliding():
				roll_finished.emit(value)

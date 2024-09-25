extends Node3D

var result = 0
var list: Array[int] = []
var dices = 1
var dice_list: Array = []
var spin_value = 1
var max_columns = 4
var spacing = 3.0
@onready var result_label = $CanvasLayer/Result

func _ready() -> void:
	var first_dice = $"Würfel"
	dice_list.append(first_dice)

func _on_würfel_roll_finished(values):
	$CanvasLayer/SpinBox.editable = false
	list.append(values)
	print(list)
	if dices == 1:
		for item in list:
			result += item
		set_result_text(result)
		list.clear()
		result = 0
		dices = spin_value
	else:
		dices -= 1

func set_result_text(result):
	result_label.text = str(result)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(result_label, "modulate", Color.WHITE, 1)
	await tween.finished
	result_label.queue_free
	result_label.text = ""

func _on_spin_box_value_changed(value: float) -> void:
	spin_value = value
	if value > dices:
		while dices < value:
			add_dice()
	elif value < dices:
		while dices > value:
			remove_dice()
			
func add_dice():
	var new_dice = preload("res://scenes/würfel.tscn").instantiate()
	var original = $"Würfel"
	var copy = original.duplicate()
	dice_list.append(copy)
	add_child(copy)
	copy.position = calculate_position(dices)
	dices += 1

func remove_dice():
	if dice_list.size() > 0:
		var last_dice = dice_list.pop_back()
		last_dice.queue_free()
	dices -= 1

func calculate_position(index: int) -> Vector3:
	var row = int(index / max_columns)
	var column = index % max_columns
	return Vector3(column * spacing, 0, row * spacing * -1)

func _on_button_reset_pressed() -> void:
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()

extends Node3D

var result = 0
var list: Array[int] = []
var dices = 3
@onready var result_label = $CanvasLayer/Label


func _on_würfel_roll_finished(values):
	list.append(values)
	if dices == 1:
		for item in list:
			result += item
		set_result_text(result)
		list.clear()
		result = 0
		dices = 3
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

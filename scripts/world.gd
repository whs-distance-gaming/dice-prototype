extends Node3D


@onready var result_label = $CanvasLayer/Label


func _on_würfel_roll_finished(value):
	result_label.text = str(value)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(result_label, "modulate", Color.WHITE, 1)
	#tween.tween_property(result_label, "scale", Vector2(), 0.25)
	#tween.tween_property(result_label, "scale", Vector2(), 0.25).set_delay(0.5)
	await tween.finished
	result_label.queue_free
	result_label.text = ""

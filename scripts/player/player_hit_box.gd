extends Area2D
signal hurt

func _on_body_entered(body):
	hurt.emit()
	
func set_active():
	monitoring = true
	
func set_inactive():
	monitoring = false


func _on_area_entered(area):
	print("hi")

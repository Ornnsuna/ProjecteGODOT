extends Area2D

signal tocat
signal sumaPunt

func _on_body_entered(body):
	tocat.emit()


func _on_area_puntuacio_body_entered(body):
	sumaPunt.emit()

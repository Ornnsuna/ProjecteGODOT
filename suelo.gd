extends Area2D

signal tocat


func _on_body_entered(body: Node2D) -> void:
	tocat.emit()

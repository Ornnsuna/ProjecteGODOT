extends CanvasLayer

signal restart


func _on_boto_restart_pressed():
	restart.emit()

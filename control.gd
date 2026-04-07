extends Control

func _on_theo_button_pressed():
	Global.personaje_seleccionado = "Theo" # Guardamos que eligió a Theo
	get_tree().change_scene_to_file("res://seccion_1.tscn") # ¡Al juego!

func _on_joy_button_pressed():
	Global.personaje_seleccionado = "Joy" # Guardamos que eligió a Joy
	get_tree().change_scene_to_file("res://seccion_1.tscn") # ¡Al juego!

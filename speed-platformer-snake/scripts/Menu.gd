extends Control
class_name Menu

const MENU_DIM_MODULATE_VALUE := .3

func enbacken(is_dim : bool):
	self.modulate.v = MENU_DIM_MODULATE_VALUE if is_dim else 1
	process_mode = Node.PROCESS_MODE_DISABLED if is_dim else Node.PROCESS_MODE_INHERIT

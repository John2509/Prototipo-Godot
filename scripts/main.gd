extends Node

func _ready():
	pass

func player_morreu(player):
	if (player == "player1"):
		print("p2 venceu")
	else:
		print("p1 venceu")
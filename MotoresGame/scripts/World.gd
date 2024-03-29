extends Node2D

var open_simplex_noise

export var num_hills = 1
export var slice = 10
export var hill_range = 100

var screensize
var terrain = PoolVector2Array()

var sand_texture = preload("res://sprites/textura_duna.png")
const base_y_offset = 200

func _ready():
	randomize()
	#Criando ruido
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	open_simplex_noise.octaves = 3 #Nº de camadas de ruído OpenSimplex que são amostradas para obter o ruído fractal.
	open_simplex_noise.period = 8 #Quanto menor o periodo mais doido o ruído.
	open_simplex_noise.lacunarity = 1.5 #Diferença no periodo entre os octaves.
	open_simplex_noise.persistence = 0.75 #Fator de contribuição dos diferentes octaves.( 1 significa que todas as oitavas têm a mesma contribuição, 0,5 cada oitava contribui com a metade do valor anterior.)
	
	
	terrain = PoolVector2Array()
	screensize = get_viewport().get_visible_rect().size
	#Setando o ponto inicial:
	var start_y = screensize.y * 3/4 + (-hill_range + 50 % hill_range*2)
	terrain.append(Vector2(0,start_y))

	generate_hills()
	pass

func _process(delta):
	#print(terrain[0])
	#print($Player.SPEED)
	if terrain[-1].x < $Player.position.x + screensize.x / 2:
		generate_hills()
	pass

func generate_hills():
	
	#Setando variaveis 
	var hill_width = screensize.x / num_hills
	var hill_slices = hill_width / slice
	var start = terrain[-1] #Start recebe o ultimo ponto do terreno

	var poly = PoolVector2Array()

	for i in range(num_hills):
		var height = int(abs(open_simplex_noise.get_noise_2d(start.x, start.y)) * 10000) % hill_range
		start.y -= height

		for j in range(0, hill_slices):
			#Criando pontos de curva:
			var hill_point = Vector2()
			hill_point.x = start.x + j * slice + hill_width * i
			hill_point.y = start.y + height * cos(2 * PI/ hill_slices * j)
			#Adcionando o ponto de curva aos vetores:
			#$Line2D.add_point(hill_point)
			terrain.append(hill_point)
			poly.append(hill_point)
		#incrementando a altura do ponto de inicio:
		start.y += height
	#Criando poligono de colisão:
	var static_B2d = StaticBody2D.new()
	add_child(static_B2d)
	var shape = CollisionPolygon2D.new()
	#$StaticBody2D.add_child(shape)
	static_B2d.add_child(shape)
	poly.append(Vector2(terrain[-1].x, screensize.y + base_y_offset))
	poly.append(Vector2(start.x, screensize.y + base_y_offset))
	shape.polygon = poly
	#aplicando textura da areia:
	var sand = Polygon2D.new()
	sand.polygon = poly
	sand.texture = sand_texture
	shape.add_child(sand)
	pass
	
func declive(x):
	return -x
	pass
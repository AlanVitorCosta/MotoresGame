extends Node2D

var open_simplex_noise

export var num_hills = 1
export var slice = 10
export var hill_range = 100

var screensize
var terrain = PoolVector2Array()

var sand_texture = preload("res://sprites/textura_duna.png")
var enemy_bugueiro = preload("res://scenes/Bugueiro.tscn")
var enemy_dromedario = preload("res://scenes/Dromedario.tscn")
var enemy_urubu = preload("res://scenes/Urubu.tscn")
var coletavel = preload("res://scenes/Coletavel.tscn")

const BASE_Y_OFFSET = 200
const BASE_X_OFFSET = 800
const RECICLAVEIS = {
	'nothing': -1,
	'garrafa': 0,
	'lata': 1,
	'plastico': 2
}

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
	screensize.x = screensize.x
	#Setando o ponto inicial:
	var start_y = screensize.y * 3/4 + (-hill_range + 50 % hill_range*2)
	terrain.append(Vector2(0,start_y))

	generate_hills()
	pass

func _process(delta):

	if terrain[-1].x < $Player.position.x + (screensize.x + BASE_X_OFFSET) / 2:
		generate_hills()
		spawn_enemy(open_simplex_noise.get_noise_2d($Player.position.x, $Player.position.y))
		spawn_item(open_simplex_noise.get_noise_2d($Player.position.x, $Player.position.x))
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
	poly.append(Vector2(terrain[-1].x, screensize.y + BASE_Y_OFFSET))
	poly.append(Vector2(start.x, screensize.y + BASE_Y_OFFSET))
	shape.polygon = poly
	#aplicando textura da areia:
	var sand = Polygon2D.new()
	sand.polygon = poly
	sand.texture = sand_texture
	shape.add_child(sand)
	pass
	
func spawn_enemy(noise_sample):
	var spawn_location = Vector2($Player.position.x + 1400, $Player.position.y - 200)
	
	if noise_sample < -0.2:
		#spawn bugueiro
		var enemy = enemy_bugueiro.instance()
		enemy.position = spawn_location
		add_child(enemy)
		return
	if noise_sample < 0:
		#spawn dromedario
		var enemy = enemy_dromedario.instance()
		enemy.position = spawn_location
		add_child(enemy)
		return
	if noise_sample < 0.2:
		#spawn urubu
		var enemy = enemy_urubu.instance()
		enemy.position = spawn_location
		add_child(enemy)
		return
	else:
		print("sem enemy")
		
	pass

func spawn_item(noise_sample):
	var spawn_location = Vector2($Player.position.x + 1400, $Player.position.y - 200)
	
	if noise_sample < -0.2:
		#lixo spawn garrafa
		var garrafa = coletavel.instance()
		garrafa.position = spawn_location
		garrafa.itemID = RECICLAVEIS.garrafa
		add_child(garrafa)
		return
	if noise_sample < 0:
		#lixo spawn lata
		var lata = coletavel.instance()
		lata.position = spawn_location
		lata.itemID = RECICLAVEIS.lata
		add_child(lata)
		return
	if noise_sample < 0.2:
		#lixo spawn plastico
		var plastico = coletavel.instance()
		plastico.position = spawn_location
		plastico.itemID = RECICLAVEIS.plastico
		add_child(plastico)
		return
	else:
		print("sem lixo")
	pass
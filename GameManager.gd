extends Node2D

var lives : int
export var SaveLocation = ""
export var MaxLives : int = 3
export var LivesRechargeNumber : int = 30
var dateOfLastLife

# Called when the node enters the scene tree for the first time.
func _ready():
	var file : File = File.new()
	if file.file_exists(SaveLocation):
		loadSavedData(file)
	else:
		lives = 3
		dateOfLastLife = OS.get_datetime()
		saveSavedData(file)
	SetUpLives()
	pass # Replace with function body.

func _process(delta):
	SetUpLives()

func loadSavedData(file : File):
	var error := file.open(SaveLocation, File.READ)
	
	if not error == OK:
		print("error file cant be opened")
		return
	
	lives = file.get_32()
	dateOfLastLife = file.get_var(true)
	$NumberOfLives.text = str(lives)
	
	file.close()
	
	pass
	
func saveSavedData(file : File = File.new()):
	file.open(SaveLocation, File.WRITE)
	file.store_32(lives)
	file.store_var(dateOfLastLife)
	
	file.close()
	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func SetUpLives():
	if lives != MaxLives:
		var time1 = OS.get_unix_time_from_datetime(dateOfLastLife)
		var time2 = OS.get_unix_time_from_datetime(OS.get_datetime())
		var minutes = (time2 - time1) / 60
		print(minutes)
		if minutes / LivesRechargeNumber > 0:
			lives += floor(minutes)
			dateOfLastLife = OS.get_datetime()
			if lives > MaxLives:
				lives = MaxLives
			saveSavedData()
		$NumberOfLives.text = str(lives)
	
func _on_Button_button_down():
	lives -= 1
	$NumberOfLives.text = str(lives)
	saveSavedData()
	pass # Replace with function body.

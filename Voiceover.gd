extends Node

var VoiceoverEnabled : bool = true

## we should make a spreadsheet for this stuffsf
##because preloading stuff is probably bad
const SAM = preload("uid://ihffm2352pmj")
const SAM1 = preload("uid://4cco2b5mg1tt")
const SAM2 = preload("uid://cfrpaw5clp0wn")
const SAM3 = preload("uid://d4evalcbrkxq6")
const SAM4 = preload("uid://dndt37xyko7mc")
const SAM5 = preload("uid://cbgclgvoup5bb")
const SAM6 = preload("uid://bhhao35mw386w")

var PlayingLine : AudioStreamPlayer
func Say(lineName : String):
	if(!VoiceoverEnabled):
		return
	
	var lineAS = self.get(lineName)
	if(lineAS):
		PlayingLine = AudioStreamPlayer.new()
		add_child(PlayingLine)
		PlayingLine.stream = lineAS
		PlayingLine.bus = "DialogueMaster"
		PlayingLine.play(0)

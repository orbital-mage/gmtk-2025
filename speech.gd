extends Node

var voice: String
var voices: PackedStringArray

func set_voice(index: int) -> bool:
	if index > voices.size() - 1:
		return false
	voice = voices[index]
	return true
	
func _ready() -> void:
	voices = DisplayServer.tts_get_voices_for_language("en")
	set_voice(0)
	
func speak(text: String):
	if text.begins_with("VOICE "):
		var number: int = text.trim_prefix("VOICE ").to_int()
		if !set_voice(number):
			speak("That voice doesn't exist")
			return
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(text, voice)

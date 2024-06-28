extends Node
class_name SFX

@onready var bgm_player: AudioStreamPlayer = $BGM
@onready var tpu_player: AudioStreamPlayer = $TemporalPowerUp
@onready var bb_player: AudioStreamPlayer = $BrokenBrick
@onready var hb_player: AudioStreamPlayer = $HitBrick
@onready var ph_player: AudioStreamPlayer = $PlayerHit
@onready var wh_player: AudioStreamPlayer = $WallHit
@onready var l_player: AudioStreamPlayer = $Loss
@onready var al_player: AudioStreamPlayer = $AfterLoss


func play_bgm() -> void:
	bgm_player.play()

func power_up() -> void:
	lower_bgm()
	tpu_player.play()

func broken_brick() -> void:
	bb_player.play()

func hit_brick() -> void:
	hb_player.play()

func player_hit() -> void:
	ph_player.play()

func wall_hit() -> void:
	wh_player.play()

func loss() -> void:
	lower_bgm()
	l_player.play()

func restart_bgm() -> void:
	var tween: Tween = create_tween()
	if(al_player.playing):
		al_player.stop()
	tween.tween_property(bgm_player, "volume_db", -10, 0.5)

func lower_bgm() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(bgm_player, "volume_db", -999, 0.5)

func _on___temporal_power_up_finished() -> void:
	restart_bgm()

func _on___loss_finished() -> void:
	al_player.play()

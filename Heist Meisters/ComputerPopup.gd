extends Popup

func set_text(combination):
	$RichTextLabel.bbcode_text = "Bro stop forgetting your code. I've set it to " + PoolStringArray(combination).join("") + " - Love Brenty"
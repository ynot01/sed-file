extends Node

## sed-file is sed-like but takes in arguments which are text files to sidestep sanitization madness
## Text is expected to be UTF-8
## Arg 1: Input file. Upon successful execution, this file will be modified
## Arg 2: Pattern file. Not regex. Takes a file of characters and tries to find them in Arg 1
## Arg 3: Replace file. Takes a file of characters to replace found pattern(s) with
func _ready() -> void:
	var args:Array = OS.get_cmdline_user_args()
	
	if len(args) == 0:
		push_error("Usage: sed-file --headless -- [INPUT FILE] [PATTERN FILE] [REPLACE FILE]")
		get_tree().quit(1)
		return
	
	if len(args) != 3:
		push_error("Need three file arguments. Exiting.")
		get_tree().quit(2)
		return
	
	var trim_amt:int = 1
	
	var input_file:String
	var n:int = 0
	var input:String
	var pattern:String
	var replace:String
	for file_string in args:
		if !FileAccess.file_exists(file_string):
			push_error("File \"", file_string, "\" does not exist. Exiting.")
			get_tree().quit(3)
			return
		
		if FileAccess.get_file_as_string(file_string).contains("\r\n"):
			trim_amt = 2
		
		match n:
			0:
				input_file = file_string
				input = FileAccess.get_file_as_string(file_string).left(-trim_amt) # Trims end newline
			1: pattern = FileAccess.get_file_as_string(file_string).left(-trim_amt)
			2: replace = FileAccess.get_file_as_string(file_string).left(-trim_amt)
		n += 1
	
	if !input.contains(pattern):
		push_error("Input string: ", input)
		push_error("Pattern string: ", pattern)
		push_error("Input file does not contain pattern. Exiting.")
		get_tree().quit(4)
		return
	
	var input_file_access := FileAccess.open(input_file, FileAccess.WRITE)
	if input_file_access == null:
		push_error(FileAccess.get_open_error())
		push_error("Input file could not be opened. Exiting.")
		get_tree().quit(5)
		return
	
	if !input_file_access.store_string(input.replace(pattern, replace)):
		push_error("Input file could not be written to. Exiting.")
		get_tree().quit(6)
		return
	
	input_file_access.close()
	
	print("Successfully written to input file.")
	get_tree().quit(0)
	return

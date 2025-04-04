# sed-file

Made for my own purposes

#

sed-file is sed-like but takes in arguments which are text files to sidestep sanitization madness

Text is expected to be UTF-8

Arg 1: Input file. Upon successful execution, this file will be modified

Arg 2: Pattern file. Not regex. Takes a file of characters and tries to find them in Arg 1

Arg 3: Replace file. Takes a file of characters to replace found pattern(s) with

#

USAGE:

`sed-file.exe --headless -- [INPUT FILE] [PATTERN FILE] [REPLACE FILE]`

Note the second double-hyphen
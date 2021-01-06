@echo off
"tools/asm68k.exe" /o ae- /p "sound/z80/z80.asm", z80.unc, , z80.lst >z80.log
"tools/asm68k.exe" /o ae- /p main.asm, out.md, , out.lst>out.log
type out.log
if not exist out.md pause & exit
rem "tools/fixheadr.exe" out.md
del out.log

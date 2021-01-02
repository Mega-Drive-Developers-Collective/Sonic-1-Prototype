@echo off
"asm68k.exe" /m /p main.asm, out.md, , out.lst>out.log
type out.log
if not exist out.md pause & exit
"fixheadr.exe" out.md
del out.log

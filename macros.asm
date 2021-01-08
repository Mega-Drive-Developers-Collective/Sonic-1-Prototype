			opt ae-		; temporary!!!
		include "tools/LANG.ASM"

align		macro pos
		dcb.b ((\pos)-(offset(*)%(\pos)))%(\pos),$FF
	endm
; ---------------------------------------------------------------------------

; enum object, width 64 bytes
id		equ 0
render		equ 1
tile		equ 2
map		equ 4
xpos		equ 8
xpix		equ $A
ypos		equ $C
ypix		equ $E
xvel		equ $10
yvel		equ $12
yrad		equ $16
xrad		equ $17
xdisp		equ $18
prio		equ $19
frame		equ $1A
anipos		equ $1B
ani		equ $1C
anilast		equ $1D
anidelay	equ $1E
col		equ $20
colprop		equ $21
status		equ $22
respawn		equ $23
routine		equ $24
routine2	equ $25
angle		equ $26
subtype		equ $28
size		equ $40

; ---------------------------------------------------------------------------

; enum player, width 64 bytes
inertia		equ $14
air		equ $20
invulnerable	equ $30
invincible	equ $32
speedshoes	equ $34
sensorfront	equ $36
sensorback	equ $37
convex		equ $38
jumping		equ $3C
platform	equ $3D
lock		equ $3E

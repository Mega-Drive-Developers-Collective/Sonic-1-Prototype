; Object variables
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes if percision is required)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes if percision is required)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obInertia:	equ $14	; potential speed (2 bytes)
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obActWid:	equ $19	; action width
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obNextAni:	equ $1D	; next animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag

; Object variables used by Sonic
flashtime:	equ $30	; time between flashes after getting hit
invtime:	equ $32	; time left for invincibility
shoetime:	equ $34	; time left for speed shoes
obFrontAngle:	equ $36
obRearAngle:	equ $37
obOnWheel:	equ $38	; on convex wheel flag
obRestartTimer:	equ $3A ; level restart timer
obJumping:	equ $3C	; jumping flag
obPlatformID:	equ $3D	; ost slot of the object Sonic's on top of
obLRLock:	equ $3E	; flag for preventing left and right input

; Object specific
Smash_speed:	equ $30		; Sonic's horizontal speed